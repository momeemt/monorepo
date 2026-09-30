package report

import (
	"fmt"
	"io"
	"sort"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

type Summary struct {
	CacheName         string
	Target            string
	DryRun            bool
	DiagDir           string
	Jobs              uint64
	ChunkTargetBytes  uint64
	MaxPathNARBytes   uint64
	OutPathCount      int
	PathInfoJSONCount int
	ClosurePathCount  int
	UploadPathCount   int
	SkippedPathCount  int
	ChunkCount        int
}

func WriteText(w io.Writer, summary Summary) error {
	lines := []string{
		fmt.Sprintf("cache=%s", summary.CacheName),
		fmt.Sprintf("target=%s", summary.Target),
		fmt.Sprintf("dry_run=%t", summary.DryRun),
		fmt.Sprintf("diag_dir=%s", summary.DiagDir),
		fmt.Sprintf("attic_jobs=%d", summary.Jobs),
		fmt.Sprintf("chunk_target_bytes=%d", summary.ChunkTargetBytes),
		fmt.Sprintf("max_path_nar_bytes=%d", summary.MaxPathNARBytes),
		fmt.Sprintf("out_path_count=%d", summary.OutPathCount),
		fmt.Sprintf("path_info_json_count=%d", summary.PathInfoJSONCount),
		fmt.Sprintf("closure_path_count=%d", summary.ClosurePathCount),
		fmt.Sprintf("upload_path_count=%d", summary.UploadPathCount),
		fmt.Sprintf("skipped_path_count=%d", summary.SkippedPathCount),
		fmt.Sprintf("chunk_count=%d", summary.ChunkCount),
	}

	for _, line := range lines {
		if _, err := fmt.Fprintln(w, line); err != nil {
			return err
		}
	}

	return nil
}

func WriteGitHubStepSummary(w io.Writer, summary Summary) error {
	_, err := fmt.Fprintf(w, `### Attic pack

- Target: %s
- Cache: %s
- Dry run: %t
- Attic jobs: %d
- Chunk target bytes: %d
- Max path NAR bytes: %d
- Out paths: %d
- Path-info JSON files: %d
- Closure paths: %d
- Upload paths: %d
- Skipped paths: %d
- Chunks: %d
- Diagnostics dir: %s

`,
		summary.Target,
		summary.CacheName,
		summary.DryRun,
		summary.Jobs,
		summary.ChunkTargetBytes,
		summary.MaxPathNARBytes,
		summary.OutPathCount,
		summary.PathInfoJSONCount,
		summary.ClosurePathCount,
		summary.UploadPathCount,
		summary.SkippedPathCount,
		summary.ChunkCount,
		summary.DiagDir,
	)
	return err
}

func WriteSkippedText(w io.Writer, skipped []plan.SkippedEntry, limit int) error {
	if len(skipped) == 0 || limit <= 0 {
		return nil
	}

	if _, err := fmt.Fprintln(w, "skipped_paths_top_by_nar_size=true"); err != nil {
		return err
	}
	for _, entry := range TopSkipped(skipped, limit) {
		if _, err := fmt.Fprintf(w, "skip reason=%s nar_size_bytes=%d path=%s\n", entry.Reason, entry.Entry.Size, entry.Entry.Path); err != nil {
			return err
		}
	}

	return nil
}

func TopSkipped(skipped []plan.SkippedEntry, limit int) []plan.SkippedEntry {
	if limit <= 0 {
		return nil
	}

	sorted := append([]plan.SkippedEntry(nil), skipped...)
	sort.Slice(sorted, func(i, j int) bool {
		if sorted[i].Entry.Size != sorted[j].Entry.Size {
			return sorted[i].Entry.Size > sorted[j].Entry.Size
		}
		if sorted[i].Reason != sorted[j].Reason {
			return sorted[i].Reason < sorted[j].Reason
		}
		return sorted[i].Entry.Path < sorted[j].Entry.Path
	})

	if len(sorted) > limit {
		sorted = sorted[:limit]
	}
	return sorted
}
