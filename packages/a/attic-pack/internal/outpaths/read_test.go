package outpaths

import (
	"strings"
	"testing"
)

func TestRead(t *testing.T) {
	paths, err := Read(strings.NewReader("/nix/store/aaa\n\n/nix/store/bbb\r\n"))
	if err != nil {
		t.Fatal(err)
	}

	want := []string{"/nix/store/aaa", "/nix/store/bbb"}
	if !equalStrings(paths, want) {
		t.Fatalf("paths = %#v, want %#v", paths, want)
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
