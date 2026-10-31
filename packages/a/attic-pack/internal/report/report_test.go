package report

import (
	"strings"
	"testing"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

func TestWriteText(t *testing.T) {
	var out strings.Builder
	err := WriteText(&out, Summary{
		CacheName:         "cache",
		Target:            "target",
		DryRun:            true,
		DiagDir:           "diag",
		Jobs:              2,
		ChunkTargetBytes:  30,
		MaxPathNARBytes:   20,
		OutPathCount:      1,
		PathInfoJSONCount: 2,
		ClosurePathCount:  3,
		UploadPathCount:   4,
		SkippedPathCount:  5,
		ChunkCount:        6,
	})
	if err != nil {
		t.Fatal(err)
	}

	for _, want := range []string{
		"cache=cache\n",
		"target=target\n",
		"dry_run=true\n",
		"chunk_count=6\n",
	} {
		if !strings.Contains(out.String(), want) {
			t.Fatalf("out = %q, want it to contain %q", out.String(), want)
		}
	}
}

func TestWriteGitHubStepSummary(t *testing.T) {
	var out strings.Builder
	err := WriteGitHubStepSummary(&out, Summary{
		CacheName: "cache",
		Target:    "target",
		DiagDir:   "diag",
	})
	if err != nil {
		t.Fatal(err)
	}

	if !strings.Contains(out.String(), "### Attic pack\n") {
		t.Fatalf("out = %q, want GitHub summary heading", out.String())
	}
	if !strings.Contains(out.String(), "- Cache: cache\n") {
		t.Fatalf("out = %q, want cache line", out.String())
	}
}

func TestTopSkipped(t *testing.T) {
	skipped := []plan.SkippedEntry{
		{Reason: plan.SkipReasonExcludedByRegex, Entry: plan.Entry{Size: 10, Path: "/nix/store/aaa"}},
		{Reason: plan.SkipReasonNARSizeOverLimit, Entry: plan.Entry{Size: 30, Path: "/nix/store/bbb"}},
		{Reason: plan.SkipReasonExcludedByRegex, Entry: plan.Entry{Size: 20, Path: "/nix/store/ccc"}},
	}

	top := TopSkipped(skipped, 2)
	want := []plan.SkippedEntry{
		{Reason: plan.SkipReasonNARSizeOverLimit, Entry: plan.Entry{Size: 30, Path: "/nix/store/bbb"}},
		{Reason: plan.SkipReasonExcludedByRegex, Entry: plan.Entry{Size: 20, Path: "/nix/store/ccc"}},
	}

	if !equalSkippedEntries(top, want) {
		t.Fatalf("top = %#v, want %#v", top, want)
	}
}

func TestWriteSkippedText(t *testing.T) {
	var out strings.Builder
	err := WriteSkippedText(&out, []plan.SkippedEntry{
		{Reason: plan.SkipReasonExcludedByRegex, Entry: plan.Entry{Size: 10, Path: "/nix/store/aaa"}},
	}, 20)
	if err != nil {
		t.Fatal(err)
	}

	if got, want := out.String(), "skipped_paths_top_by_nar_size=true\nskip reason=excluded-by-regex nar_size_bytes=10 path=/nix/store/aaa\n"; got != want {
		t.Fatalf("out = %q, want %q", got, want)
	}
}

func equalSkippedEntries(got, want []plan.SkippedEntry) bool {
	if len(got) != len(want) {
		return false
	}
	for i := range got {
		if got[i] != want[i] {
			return false
		}
	}
	return true
}
