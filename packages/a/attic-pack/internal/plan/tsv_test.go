package plan

import (
	"strings"
	"testing"
)

func TestReadPathSizes(t *testing.T) {
	entries, err := ReadPathSizes(strings.NewReader("10\t/nix/store/aaa\n20\t/nix/store/bbb\n"))
	if err != nil {
		t.Fatal(err)
	}

	if got, want := len(entries), 2; got != want {
		t.Fatalf("len(entries) = %d, want %d", got, want)
	}
	if got, want := entries[1], (Entry{Size: 20, Path: "/nix/store/bbb"}); got != want {
		t.Fatalf("entries[1] = %#v, want %#v", got, want)
	}
}

func TestReadPathSizesRejectsInvalidRows(t *testing.T) {
	_, err := ReadPathSizes(strings.NewReader("not-a-size\t/nix/store/aaa\n"))
	if err == nil {
		t.Fatal("ReadPathSizes returned nil error")
	}
}

func TestWritePathSizes(t *testing.T) {
	var out strings.Builder
	err := WritePathSizes(&out, []Entry{
		{Size: 10, Path: "/nix/store/aaa"},
		{Size: 20, Path: "/nix/store/bbb"},
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := out.String(), "10\t/nix/store/aaa\n20\t/nix/store/bbb\n"; got != want {
		t.Fatalf("out = %q, want %q", got, want)
	}
}

func TestWritePaths(t *testing.T) {
	var out strings.Builder
	err := WritePaths(&out, []Entry{
		{Size: 10, Path: "/nix/store/aaa"},
		{Size: 20, Path: "/nix/store/bbb"},
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := out.String(), "/nix/store/aaa\n/nix/store/bbb\n"; got != want {
		t.Fatalf("out = %q, want %q", got, want)
	}
}

func TestWriteSkippedPathSizes(t *testing.T) {
	var out strings.Builder
	err := WriteSkippedPathSizes(&out, []SkippedEntry{
		{
			Reason: SkipReasonExcludedByRegex,
			Entry:  Entry{Size: 20, Path: "/nix/store/bbb"},
		},
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := out.String(), "excluded-by-regex\t20\t/nix/store/bbb\n"; got != want {
		t.Fatalf("out = %q, want %q", got, want)
	}
}
