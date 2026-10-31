package atticpush

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

type Runner func(chunkFile string) error

func CommandRunner(atticBin string, cacheName string, jobs uint64) Runner {
	return func(chunkFile string) error {
		input, err := os.Open(chunkFile)
		if err != nil {
			return err
		}
		defer input.Close()

		command := exec.Command(atticBin, "push", "--stdin", "--no-closure", "-j", strconv.FormatUint(jobs, 10), cacheName)
		command.Stdin = input
		command.Stdout = os.Stdout
		command.Stderr = os.Stderr

		if err := command.Run(); err != nil {
			if exitErr, ok := err.(*exec.ExitError); ok {
				stderr := strings.TrimSpace(string(exitErr.Stderr))
				if stderr != "" {
					return fmt.Errorf("%w: %s", err, stderr)
				}
			}
			return err
		}

		return nil
	}
}

func PushChunks(chunkFiles []string, runner Runner) error {
	if runner == nil {
		return fmt.Errorf("runner is nil")
	}

	for _, chunkFile := range chunkFiles {
		if err := runner(chunkFile); err != nil {
			return fmt.Errorf("%s: %w", chunkFile, err)
		}
	}

	return nil
}
