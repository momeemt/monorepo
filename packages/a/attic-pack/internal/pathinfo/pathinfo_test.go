package pathinfo

import (
	"strings"
	"testing"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

func TestRead(t *testing.T) {
	entries, err := Read(strings.NewReader(`{
		"/nix/store/bbb": {"narSize": 20, "closureSize": 200},
		"/nix/store/aaa": {"closureSize": 100}
	}`))
	if err != nil {
		t.Fatal(err)
	}

	entries = Normalize(entries)
	want := []plan.Entry{
		{Size: 0, Path: "/nix/store/aaa"},
		{Size: 20, Path: "/nix/store/bbb"},
	}

	if !equalEntries(entries, want) {
		t.Fatalf("entries = %#v, want %#v", entries, want)
	}
}

func TestNormalizeKeepsLargestSizePerPath(t *testing.T) {
	entries := Normalize([]plan.Entry{
		{Size: 10, Path: "/nix/store/aaa"},
		{Size: 30, Path: "/nix/store/bbb"},
		{Size: 12, Path: "/nix/store/aaa"},
		{Size: 5, Path: "/nix/store/ccc"},
	})

	want := []plan.Entry{
		{Size: 5, Path: "/nix/store/ccc"},
		{Size: 12, Path: "/nix/store/aaa"},
		{Size: 30, Path: "/nix/store/bbb"},
	}

	if !equalEntries(entries, want) {
		t.Fatalf("entries = %#v, want %#v", entries, want)
	}
}

func equalEntries(got, want []plan.Entry) bool {
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
