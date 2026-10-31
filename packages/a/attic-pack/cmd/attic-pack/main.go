package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/atticpush"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/chunk"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/nixpathinfo"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/outpaths"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/pathinfo"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/report"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "attic-pack: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) == 0 {
		return usageError("missing command")
	}

	switch args[0] {
	case "chunk":
		return runChunk(args[1:])
	case "collect-json":
		return runCollectJSON(args[1:])
	case "plan":
		return runPlan(args[1:])
	case "path-sizes":
		return runPathSizes(args[1:])
	case "push":
		return runPush(args[1:])
	default:
		return usageError(fmt.Sprintf("unknown command %q", args[0]))
	}
}

func runChunk(args []string) error {
	flags := flag.NewFlagSet("chunk", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	uploadPathSizesPath := flags.String("upload-path-sizes", "", "input TSV file containing selected NAR size and store path")
	chunkDir := flags.String("chunk-dir", "", "output directory for chunk files")
	chunkTargetBytes := flags.Uint64("chunk-target-bytes", 0, "target total NAR size per chunk; 0 disables splitting")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *uploadPathSizesPath == "" {
		return usageError("missing --upload-path-sizes")
	}
	if *chunkDir == "" {
		return usageError("missing --chunk-dir")
	}

	input, err := os.Open(*uploadPathSizesPath)
	if err != nil {
		return fmt.Errorf("open --upload-path-sizes: %w", err)
	}
	defer input.Close()

	entries, err := plan.ReadPathSizes(input)
	if err != nil {
		return fmt.Errorf("read --upload-path-sizes: %w", err)
	}

	chunks := chunk.Build(entries, chunk.Options{
		TargetBytes: *chunkTargetBytes,
	})

	files, err := chunk.WriteFiles(*chunkDir, chunks)
	if err != nil {
		return fmt.Errorf("write --chunk-dir: %w", err)
	}

	fmt.Printf("input_path_count=%d\n", len(entries))
	fmt.Printf("chunk_count=%d\n", len(chunks))
	for _, file := range files {
		fmt.Printf("chunk_file=%s\n", file)
	}

	return nil
}

func runCollectJSON(args []string) error {
	flags := flag.NewFlagSet("collect-json", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	outPathsPath := flags.String("out-paths", "", "input file containing nix build output paths")
	jsonDir := flags.String("json-dir", "", "output directory for path-info JSON files")
	nixBin := flags.String("nix-bin", "nix", "nix executable path")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *outPathsPath == "" {
		return usageError("missing --out-paths")
	}
	if *jsonDir == "" {
		return usageError("missing --json-dir")
	}

	input, err := os.Open(*outPathsPath)
	if err != nil {
		return fmt.Errorf("open --out-paths: %w", err)
	}
	defer input.Close()

	paths, err := outpaths.Read(input)
	if err != nil {
		return fmt.Errorf("read --out-paths: %w", err)
	}
	if len(paths) == 0 {
		return fmt.Errorf("read --out-paths: no output paths found")
	}

	files, err := nixpathinfo.CollectJSON(paths, *jsonDir, nixpathinfo.CommandRunner(*nixBin))
	if err != nil {
		return fmt.Errorf("collect path-info JSON: %w", err)
	}

	fmt.Printf("out_path_count=%d\n", len(paths))
	fmt.Printf("path_info_json_count=%d\n", len(files))
	for _, file := range files {
		fmt.Printf("path_info_json=%s\n", file)
	}

	return nil
}

func runPush(args []string) error {
	defaultChunkTargetBytes, err := envUint64("ATTIC_PUSH_CHUNK_TARGET_BYTES", 2147483648)
	if err != nil {
		return err
	}
	defaultMaxPathNARBytes, err := envUint64("ATTIC_PUSH_MAX_PATH_NAR_BYTES", 0)
	if err != nil {
		return err
	}
	defaultJobs, err := envUint64("ATTIC_PUSH_JOBS", 1)
	if err != nil {
		return err
	}

	flags := flag.NewFlagSet("push", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	diagDir := flags.String("diag-dir", defaultDiagDir(), "diagnostics output directory")
	chunkTargetBytes := flags.Uint64("chunk-target-bytes", defaultChunkTargetBytes, "target total NAR size per chunk; 0 disables splitting")
	maxPathNARBytes := flags.Uint64("max-path-nar-bytes", defaultMaxPathNARBytes, "skip paths with NAR size above this value; 0 disables the limit")
	excludeStoreRegex := flags.String("exclude-store-regex", os.Getenv("ATTIC_EXCLUDE_STORE_REGEX"), "skip store paths matching this regular expression")
	jobs := flags.Uint64("jobs", defaultJobs, "attic push parallel jobs")
	nixBin := flags.String("nix-bin", "nix", "nix executable path")
	atticBin := flags.String("attic-bin", "attic", "attic executable path")
	dryRun := flags.Bool("dry-run", false, "write diagnostics and chunks without running attic push")

	flagArgs, positionalArgs, err := splitPushArgs(args)
	if err != nil {
		return err
	}

	if err := flags.Parse(flagArgs); err != nil {
		return err
	}
	if len(positionalArgs) != 2 {
		return usageError("push requires <cache> and <out-paths-file>")
	}

	cacheName := positionalArgs[0]
	outPathsPath := positionalArgs[1]

	var exclude *regexp.Regexp
	if *excludeStoreRegex != "" {
		compiled, err := regexp.Compile(*excludeStoreRegex)
		if err != nil {
			return fmt.Errorf("compile --exclude-store-regex: %w", err)
		}
		exclude = compiled
	}

	paths, err := readOutPathsFile(outPathsPath)
	if err != nil {
		return err
	}
	if len(paths) == 0 {
		return fmt.Errorf("read out paths: no output paths found")
	}

	if err := os.MkdirAll(*diagDir, 0o755); err != nil {
		return fmt.Errorf("create --diag-dir: %w", err)
	}

	jsonDir := filepath.Join(*diagDir, "path-info-json")
	pathInfoJSONPaths, err := nixpathinfo.CollectJSON(paths, jsonDir, nixpathinfo.CommandRunner(*nixBin))
	if err != nil {
		return fmt.Errorf("collect path-info JSON: %w", err)
	}

	closureEntries, err := readPathInfoJSONFiles(pathInfoJSONPaths)
	if err != nil {
		return err
	}
	closureEntries = pathinfo.Normalize(closureEntries)

	closurePathSizesPath := filepath.Join(*diagDir, "closure-path-sizes.tsv")
	if err := writePathSizesFile(closurePathSizesPath, closureEntries); err != nil {
		return fmt.Errorf("write closure path sizes: %w", err)
	}

	result := plan.Build(closureEntries, plan.Options{
		MaxPathNARBytes: *maxPathNARBytes,
		ExcludeStore:    exclude,
	})

	uploadPathSizesPath := filepath.Join(*diagDir, "upload-path-sizes.tsv")
	if err := writePathSizesFile(uploadPathSizesPath, result.Upload); err != nil {
		return fmt.Errorf("write upload path sizes: %w", err)
	}

	uploadPathsPath := filepath.Join(*diagDir, "upload-paths.txt")
	if err := writePathsFile(uploadPathsPath, result.Upload); err != nil {
		return fmt.Errorf("write upload paths: %w", err)
	}

	skippedPathSizesPath := filepath.Join(*diagDir, "skipped-path-sizes.tsv")
	if err := writeSkippedPathSizesFile(skippedPathSizesPath, result.Skipped); err != nil {
		return fmt.Errorf("write skipped path sizes: %w", err)
	}

	chunkDir := filepath.Join(*diagDir, "chunks")
	chunks := chunk.Build(result.Upload, chunk.Options{
		TargetBytes: *chunkTargetBytes,
	})
	chunkFiles, err := chunk.WriteFiles(chunkDir, chunks)
	if err != nil {
		return fmt.Errorf("write chunks: %w", err)
	}

	summary := report.Summary{
		CacheName:         cacheName,
		Target:            envOrDefault("MATRIX_TARGET", "unknown"),
		DryRun:            *dryRun,
		DiagDir:           *diagDir,
		Jobs:              *jobs,
		ChunkTargetBytes:  *chunkTargetBytes,
		MaxPathNARBytes:   *maxPathNARBytes,
		OutPathCount:      len(paths),
		PathInfoJSONCount: len(pathInfoJSONPaths),
		ClosurePathCount:  len(closureEntries),
		UploadPathCount:   len(result.Upload),
		SkippedPathCount:  len(result.Skipped),
		ChunkCount:        len(chunks),
	}
	if err := report.WriteText(os.Stdout, summary); err != nil {
		return fmt.Errorf("write summary: %w", err)
	}
	if err := report.WriteSkippedText(os.Stdout, result.Skipped, 20); err != nil {
		return fmt.Errorf("write skipped paths summary: %w", err)
	}
	if stepSummaryPath := os.Getenv("GITHUB_STEP_SUMMARY"); stepSummaryPath != "" {
		if err := writeGitHubStepSummary(stepSummaryPath, summary); err != nil {
			return fmt.Errorf("write GitHub step summary: %w", err)
		}
	}

	if *dryRun {
		return nil
	}
	if len(chunkFiles) == 0 {
		fmt.Println("no_paths_selected=true")
		return nil
	}

	runner := atticpush.CommandRunner(*atticBin, cacheName, *jobs)
	for index, chunkFile := range chunkFiles {
		metadata := chunks[index]
		fmt.Printf("attic_push_chunk_index=%d paths=%d estimated_nar_bytes=%d\n", metadata.Index, len(metadata.Paths), metadata.Bytes)
		err := runner(chunkFile)
		if err != nil {
			fmt.Printf("attic_push_chunk_exit_status=1 index=%d\n", metadata.Index)
			return fmt.Errorf("push chunk %d: %w", metadata.Index, err)
		}
		fmt.Printf("attic_push_chunk_exit_status=0 index=%d\n", metadata.Index)
	}

	return nil
}

func runPathSizes(args []string) error {
	flags := flag.NewFlagSet("path-sizes", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	var pathInfoJSONPaths stringList
	flags.Var(&pathInfoJSONPaths, "path-info-json", "input JSON file from nix path-info --recursive --json; may be repeated")
	pathSizesPath := flags.String("path-sizes", "", "output TSV file containing NAR size and store path")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if len(pathInfoJSONPaths) == 0 {
		return usageError("missing --path-info-json")
	}
	if *pathSizesPath == "" {
		return usageError("missing --path-sizes")
	}

	var entries []plan.Entry
	for _, jsonPath := range pathInfoJSONPaths {
		input, err := os.Open(jsonPath)
		if err != nil {
			return fmt.Errorf("open --path-info-json %q: %w", jsonPath, err)
		}

		jsonEntries, err := pathinfo.Read(input)
		closeErr := input.Close()
		if err != nil {
			return fmt.Errorf("read --path-info-json %q: %w", jsonPath, err)
		}
		if closeErr != nil {
			return fmt.Errorf("close --path-info-json %q: %w", jsonPath, closeErr)
		}

		entries = append(entries, jsonEntries...)
	}

	entries = pathinfo.Normalize(entries)
	if err := writePathSizesFile(*pathSizesPath, entries); err != nil {
		return fmt.Errorf("write --path-sizes: %w", err)
	}

	fmt.Printf("path_info_json_count=%d\n", len(pathInfoJSONPaths))
	fmt.Printf("path_size_count=%d\n", len(entries))

	return nil
}

func runPlan(args []string) error {
	flags := flag.NewFlagSet("plan", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	pathSizesPath := flags.String("path-sizes", "", "input TSV file containing NAR size and store path")
	uploadPathSizesPath := flags.String("upload-path-sizes", "", "output TSV file for selected paths")
	uploadPathsPath := flags.String("upload-paths", "", "optional output file for selected store paths")
	skippedPathSizesPath := flags.String("skipped-path-sizes", "", "output TSV file for skipped paths")
	maxPathNARBytes := flags.Uint64("max-path-nar-bytes", 0, "skip paths with NAR size above this value; 0 disables the limit")
	excludeStoreRegex := flags.String("exclude-store-regex", "", "skip store paths matching this regular expression")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *pathSizesPath == "" {
		return usageError("missing --path-sizes")
	}
	if *uploadPathSizesPath == "" {
		return usageError("missing --upload-path-sizes")
	}
	if *skippedPathSizesPath == "" {
		return usageError("missing --skipped-path-sizes")
	}

	var exclude *regexp.Regexp
	if *excludeStoreRegex != "" {
		compiled, err := regexp.Compile(*excludeStoreRegex)
		if err != nil {
			return fmt.Errorf("compile --exclude-store-regex: %w", err)
		}
		exclude = compiled
	}

	input, err := os.Open(*pathSizesPath)
	if err != nil {
		return fmt.Errorf("open --path-sizes: %w", err)
	}
	defer input.Close()

	entries, err := plan.ReadPathSizes(input)
	if err != nil {
		return fmt.Errorf("read --path-sizes: %w", err)
	}

	result := plan.Build(entries, plan.Options{
		MaxPathNARBytes: *maxPathNARBytes,
		ExcludeStore:    exclude,
	})

	if err := writePathSizesFile(*uploadPathSizesPath, result.Upload); err != nil {
		return fmt.Errorf("write --upload-path-sizes: %w", err)
	}
	if *uploadPathsPath != "" {
		if err := writePathsFile(*uploadPathsPath, result.Upload); err != nil {
			return fmt.Errorf("write --upload-paths: %w", err)
		}
	}
	if err := writeSkippedPathSizesFile(*skippedPathSizesPath, result.Skipped); err != nil {
		return fmt.Errorf("write --skipped-path-sizes: %w", err)
	}

	fmt.Printf("input_path_count=%d\n", len(entries))
	fmt.Printf("upload_path_count=%d\n", len(result.Upload))
	fmt.Printf("skipped_path_count=%d\n", len(result.Skipped))

	return nil
}

func readOutPathsFile(path string) ([]string, error) {
	input, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("open out paths: %w", err)
	}
	defer input.Close()

	paths, err := outpaths.Read(input)
	if err != nil {
		return nil, fmt.Errorf("read out paths: %w", err)
	}

	return paths, nil
}

func readPathInfoJSONFiles(paths []string) ([]plan.Entry, error) {
	var entries []plan.Entry
	for _, path := range paths {
		input, err := os.Open(path)
		if err != nil {
			return nil, fmt.Errorf("open path-info JSON %q: %w", path, err)
		}

		jsonEntries, err := pathinfo.Read(input)
		closeErr := input.Close()
		if err != nil {
			return nil, fmt.Errorf("read path-info JSON %q: %w", path, err)
		}
		if closeErr != nil {
			return nil, fmt.Errorf("close path-info JSON %q: %w", path, closeErr)
		}

		entries = append(entries, jsonEntries...)
	}

	return entries, nil
}

func writePathSizesFile(path string, entries []plan.Entry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WritePathSizes(file, entries)
}

func writePathsFile(path string, entries []plan.Entry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WritePaths(file, entries)
}

func writeSkippedPathSizesFile(path string, entries []plan.SkippedEntry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WriteSkippedPathSizes(file, entries)
}

func usageError(message string) error {
	return fmt.Errorf("%s\nusage:\n  attic-pack push <cache> <out-paths-file> [--dry-run] [--diag-dir <dir>] [--jobs <n>] [--chunk-target-bytes <bytes>] [--max-path-nar-bytes <bytes>] [--exclude-store-regex <regex>]\n  attic-pack collect-json --out-paths <file> --json-dir <dir> [--nix-bin <path>]\n  attic-pack path-sizes --path-info-json <file> [--path-info-json <file> ...] --path-sizes <file>\n  attic-pack plan --path-sizes <file> --upload-path-sizes <file> --skipped-path-sizes <file> [--upload-paths <file>] [--max-path-nar-bytes <bytes>] [--exclude-store-regex <regex>]\n  attic-pack chunk --upload-path-sizes <file> --chunk-dir <dir> [--chunk-target-bytes <bytes>]", message)
}

func defaultDiagDir() string {
	if value := os.Getenv("ATTIC_DIAG_DIR"); value != "" {
		return value
	}
	if value := os.Getenv("RUNNER_TEMP"); value != "" {
		return filepath.Join(value, "attic-diagnostics")
	}
	return filepath.Join(os.TempDir(), "attic-diagnostics")
}

func envOrDefault(name string, fallback string) string {
	if value := os.Getenv(name); value != "" {
		return value
	}
	return fallback
}

func envUint64(name string, fallback uint64) (uint64, error) {
	value := os.Getenv(name)
	if value == "" {
		return fallback, nil
	}

	parsed, err := strconv.ParseUint(value, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("%s must be an unsigned integer: %q", name, value)
	}

	return parsed, nil
}

func writeGitHubStepSummary(path string, summary report.Summary) error {
	file, err := os.OpenFile(path, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o644)
	if err != nil {
		return err
	}
	defer file.Close()

	return report.WriteGitHubStepSummary(file, summary)
}

func splitPushArgs(args []string) ([]string, []string, error) {
	valueFlags := map[string]bool{
		"attic-bin":           true,
		"chunk-target-bytes":  true,
		"diag-dir":            true,
		"exclude-store-regex": true,
		"jobs":                true,
		"max-path-nar-bytes":  true,
		"nix-bin":             true,
	}

	var flagArgs []string
	var positionalArgs []string
	for index := 0; index < len(args); index++ {
		arg := args[index]
		if arg == "--" {
			positionalArgs = append(positionalArgs, args[index+1:]...)
			break
		}
		if !strings.HasPrefix(arg, "-") {
			positionalArgs = append(positionalArgs, arg)
			continue
		}

		flagArgs = append(flagArgs, arg)
		name := strings.TrimLeft(arg, "-")
		if before, _, ok := strings.Cut(name, "="); ok {
			name = before
		}
		if valueFlags[name] && !strings.Contains(arg, "=") {
			if index+1 >= len(args) {
				return nil, nil, fmt.Errorf("missing value for %s", arg)
			}
			index++
			flagArgs = append(flagArgs, args[index])
		}
	}

	return flagArgs, positionalArgs, nil
}

type stringList []string

func (values *stringList) Set(value string) error {
	*values = append(*values, value)
	return nil
}

func (values *stringList) String() string {
	return fmt.Sprint([]string(*values))
}
