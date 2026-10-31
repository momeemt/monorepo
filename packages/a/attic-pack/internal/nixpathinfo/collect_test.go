package nixpathinfo

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestCollectJSON(t *testing.T) {
	dir := t.TempDir()
	files, err := CollectJSON([]string{
		"/nix/store/aaa",
		"/nix/store/bbb",
	}, dir, func(outPath string) ([]byte, error) {
		return []byte(fmt.Sprintf(`{"%s":{"narSize":10}}`, outPath)), nil
	})
	if err != nil {
		t.Fatal(err)
	}

	if got, want := len(files), 2; got != want {
		t.Fatalf("len(files) = %d, want %d", got, want)
	}
	if got, want := filepath.Base(files[0]), "path-info-0000.json"; got != want {
		t.Fatalf("filepath.Base(files[0]) = %q, want %q", got, want)
	}

	content, err := os.ReadFile(filepath.Join(dir, "path-info-0001.json"))
	if err != nil {
		t.Fatal(err)
	}
	if got, want := string(content), `{"/nix/store/bbb":{"narSize":10}}`; got != want {
		t.Fatalf("content = %q, want %q", got, want)
	}
}

func TestCollectJSONRequiresEmptyDirectory(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "existing"), []byte("x"), 0o644); err != nil {
		t.Fatal(err)
	}

	_, err := CollectJSON([]string{"/nix/store/aaa"}, dir, func(outPath string) ([]byte, error) {
		return []byte("{}"), nil
	})
	if err == nil {
		t.Fatal("CollectJSON returned nil error")
	}
}

func TestCollectJSONIncludesOutPathInRunnerError(t *testing.T) {
	_, err := CollectJSON([]string{"/nix/store/aaa"}, t.TempDir(), func(outPath string) ([]byte, error) {
		return nil, fmt.Errorf("failed")
	})
	if err == nil {
		t.Fatal("CollectJSON returned nil error")
	}
	if !strings.Contains(err.Error(), "/nix/store/aaa") {
		t.Fatalf("err = %q, want it to contain out path", err.Error())
	}
}
