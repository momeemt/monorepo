package nixpathinfo

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

type Runner func(outPath string) ([]byte, error)

func CommandRunner(nixBin string) Runner {
	return func(outPath string) ([]byte, error) {
		command := exec.Command(nixBin, "path-info", "--recursive", "--json", outPath)
		output, err := command.Output()
		if err != nil {
			if exitErr, ok := err.(*exec.ExitError); ok {
				stderr := strings.TrimSpace(string(exitErr.Stderr))
				if stderr != "" {
					return nil, fmt.Errorf("%w: %s", err, stderr)
				}
			}
			return nil, err
		}

		return output, nil
	}
}

func CollectJSON(outPaths []string, dir string, runner Runner) ([]string, error) {
	if runner == nil {
		return nil, fmt.Errorf("runner is nil")
	}
	if err := ensureEmptyDir(dir); err != nil {
		return nil, err
	}

	files := make([]string, 0, len(outPaths))
	for index, outPath := range outPaths {
		output, err := runner(outPath)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", outPath, err)
		}

		path := filepath.Join(dir, fmt.Sprintf("path-info-%04d.json", index))
		if err := os.WriteFile(path, output, 0o644); err != nil {
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
