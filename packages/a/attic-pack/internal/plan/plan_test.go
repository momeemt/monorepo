package plan

import (
	"regexp"
	"testing"
)

func TestBuildSelectsUploadAndSkippedEntries(t *testing.T) {
	entries := []Entry{
		{Size: 10, Path: "/nix/store/aaa-small"},
		{Size: 30, Path: "/nix/store/bbb-large"},
		{Size: 20, Path: "/nix/store/ccc-excluded"},
	}

	result := Build(entries, Options{
		MaxPathNARBytes: 25,
		ExcludeStore:    regexp.MustCompile(`excluded$`),
	})

	if got, want := len(result.Upload), 1; got != want {
		t.Fatalf("len(result.Upload) = %d, want %d", got, want)
	}
	if got, want := result.Upload[0].Path, "/nix/store/aaa-small"; got != want {
		t.Fatalf("result.Upload[0].Path = %q, want %q", got, want)
	}

	if got, want := len(result.Skipped), 2; got != want {
		t.Fatalf("len(result.Skipped) = %d, want %d", got, want)
	}
	if got, want := result.Skipped[0].Reason, SkipReasonNARSizeOverLimit; got != want {
		t.Fatalf("result.Skipped[0].Reason = %q, want %q", got, want)
	}
	if got, want := result.Skipped[1].Reason, SkipReasonExcludedByRegex; got != want {
		t.Fatalf("result.Skipped[1].Reason = %q, want %q", got, want)
	}
}

func TestBuildPrefersSizeLimitOverRegex(t *testing.T) {
	result := Build([]Entry{
		{Size: 30, Path: "/nix/store/aaa-excluded"},
	}, Options{
		MaxPathNARBytes: 25,
		ExcludeStore:    regexp.MustCompile(`excluded$`),
	})

	if got, want := len(result.Skipped), 1; got != want {
		t.Fatalf("len(result.Skipped) = %d, want %d", got, want)
	}
	if got, want := result.Skipped[0].Reason, SkipReasonNARSizeOverLimit; got != want {
		t.Fatalf("result.Skipped[0].Reason = %q, want %q", got, want)
	}
}
