package atticpush

import (
	"fmt"
	"strings"
	"testing"
)

func TestPushChunks(t *testing.T) {
	var pushed []string
	err := PushChunks([]string{
		"chunk-0001.txt",
		"chunk-0002.txt",
	}, func(chunkFile string) error {
		pushed = append(pushed, chunkFile)
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}

	want := []string{"chunk-0001.txt", "chunk-0002.txt"}
	if !equalStrings(pushed, want) {
		t.Fatalf("pushed = %#v, want %#v", pushed, want)
	}
}

func TestPushChunksStopsOnError(t *testing.T) {
	var pushed []string
	err := PushChunks([]string{
		"chunk-0001.txt",
		"chunk-0002.txt",
	}, func(chunkFile string) error {
		pushed = append(pushed, chunkFile)
		return fmt.Errorf("failed")
	})
	if err == nil {
		t.Fatal("PushChunks returned nil error")
	}
	if !strings.Contains(err.Error(), "chunk-0001.txt") {
		t.Fatalf("err = %q, want it to contain chunk file", err.Error())
	}

	want := []string{"chunk-0001.txt"}
	if !equalStrings(pushed, want) {
		t.Fatalf("pushed = %#v, want %#v", pushed, want)
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
