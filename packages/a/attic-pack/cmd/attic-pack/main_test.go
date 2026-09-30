package main

import "testing"

func TestSplitPushArgsAllowsFlagsAfterPositionals(t *testing.T) {
	flagArgs, positionalArgs, err := splitPushArgs([]string{
		"cache",
		"out-paths.txt",
		"--dry-run",
		"--diag-dir",
		"diag",
		"--jobs=3",
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := positionalArgs, []string{"cache", "out-paths.txt"}; !equalStrings(got, want) {
		t.Fatalf("positionalArgs = %#v, want %#v", got, want)
	}
	if got, want := flagArgs, []string{"--dry-run", "--diag-dir", "diag", "--jobs=3"}; !equalStrings(got, want) {
		t.Fatalf("flagArgs = %#v, want %#v", got, want)
	}
}

func TestSplitPushArgsRequiresValueFlagValue(t *testing.T) {
	_, _, err := splitPushArgs([]string{
		"cache",
		"out-paths.txt",
		"--diag-dir",
	})
	if err == nil {
		t.Fatal("splitPushArgs returned nil error")
	}
}

func equalStrings(got, want []string) bool {
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
