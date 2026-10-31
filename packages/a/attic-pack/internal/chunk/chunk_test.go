package chunk

import (
	"testing"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

func TestBuildSplitsByTargetBytes(t *testing.T) {
	chunks := Build([]plan.Entry{
		{Size: 10, Path: "/nix/store/aaa"},
		{Size: 20, Path: "/nix/store/bbb"},
		{Size: 15, Path: "/nix/store/ccc"},
	}, Options{TargetBytes: 30})

	if got, want := len(chunks), 2; got != want {
		t.Fatalf("len(chunks) = %d, want %d", got, want)
	}
	if got, want := chunks[0].Bytes, uint64(30); got != want {
		t.Fatalf("chunks[0].Bytes = %d, want %d", got, want)
	}
	if got, want := chunks[1].Bytes, uint64(15); got != want {
		t.Fatalf("chunks[1].Bytes = %d, want %d", got, want)
	}
}

func TestBuildDoesNotSplitWhenTargetBytesIsZero(t *testing.T) {
	chunks := Build([]plan.Entry{
		{Size: 10, Path: "/nix/store/aaa"},
		{Size: 20, Path: "/nix/store/bbb"},
	}, Options{TargetBytes: 0})

	if got, want := len(chunks), 1; got != want {
		t.Fatalf("len(chunks) = %d, want %d", got, want)
	}
	if got, want := chunks[0].Bytes, uint64(30); got != want {
		t.Fatalf("chunks[0].Bytes = %d, want %d", got, want)
	}
}

func TestBuildKeepsOversizedEntryInSingleChunk(t *testing.T) {
	chunks := Build([]plan.Entry{
		{Size: 50, Path: "/nix/store/aaa"},
		{Size: 10, Path: "/nix/store/bbb"},
	}, Options{TargetBytes: 30})

	if got, want := len(chunks), 2; got != want {
		t.Fatalf("len(chunks) = %d, want %d", got, want)
	}
	if got, want := chunks[0].Bytes, uint64(50); got != want {
		t.Fatalf("chunks[0].Bytes = %d, want %d", got, want)
	}
}

func TestBuildReturnsNoChunksForEmptyInput(t *testing.T) {
	chunks := Build(nil, Options{TargetBytes: 30})

	if got, want := len(chunks), 0; got != want {
		t.Fatalf("len(chunks) = %d, want %d", got, want)
	}
}
