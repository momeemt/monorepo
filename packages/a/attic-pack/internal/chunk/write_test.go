package chunk

import (
	"os"
	"path/filepath"
	"testing"
)

func TestWriteFiles(t *testing.T) {
	dir := t.TempDir()

	files, err := WriteFiles(dir, []Chunk{
		{Index: 1, Bytes: 10, Paths: []string{"/nix/store/aaa"}},
		{Index: 2, Bytes: 20, Paths: []string{"/nix/store/bbb", "/nix/store/ccc"}},
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := len(files), 2; got != want {
		t.Fatalf("len(files) = %d, want %d", got, want)
	}
	if got, want := filepath.Base(files[0]), "chunk-0001.txt"; got != want {
		t.Fatalf("filepath.Base(files[0]) = %q, want %q", got, want)
	}

	content, err := os.ReadFile(filepath.Join(dir, "chunk-0002.txt"))
	if err != nil {
		t.Fatal(err)
	}
	if got, want := string(content), "/nix/store/bbb\n/nix/store/ccc\n"; got != want {
		t.Fatalf("content = %q, want %q", got, want)
	}
}

func TestWriteFilesRequiresEmptyDirectory(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "existing"), []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}

	_, err := WriteFiles(dir, []Chunk{
		{Index: 1, Bytes: 10, Paths: []string{"/nix/store/aaa"}},
	})
	if err == nil {
		t.Fatal("WriteFiles returned nil error")
	}
}
