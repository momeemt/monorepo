package chunk

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
)

func WriteFiles(dir string, chunks []Chunk) ([]string, error) {
	if err := ensureEmptyDir(dir); err != nil {
		return nil, err
	}

	files := make([]string, 0, len(chunks))
	for _, chunk := range chunks {
		path := filepath.Join(dir, fmt.Sprintf("chunk-%04d.txt", chunk.Index))
		if err := writeChunkFile(path, chunk); err != nil {
			return nil, err
		}
		files = append(files, path)
	}

	return files, nil
}

func ensureEmptyDir(dir string) error {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}

	entries, err := os.ReadDir(dir)
	if err != nil {
		return err
	}
	if len(entries) != 0 {
		return fmt.Errorf("directory must be empty: %s", dir)
	}

	return nil
}

func writeChunkFile(path string, chunk Chunk) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	buffered := bufio.NewWriter(file)
	for _, storePath := range chunk.Paths {
		if _, err := fmt.Fprintln(buffered, storePath); err != nil {
			return err
		}
	}

	return buffered.Flush()
}
