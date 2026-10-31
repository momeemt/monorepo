package plan

import (
	"bufio"
	"fmt"
	"io"
	"strconv"
	"strings"
)

func ReadPathSizes(r io.Reader) ([]Entry, error) {
	scanner := bufio.NewScanner(r)
	scanner.Buffer(make([]byte, 1024), 1024*1024)

	var entries []Entry
	lineNumber := 0
	for scanner.Scan() {
		lineNumber++
		line := strings.TrimSuffix(scanner.Text(), "\r")
		if line == "" {
			continue
		}

		sizeText, path, ok := strings.Cut(line, "\t")
		if !ok || path == "" {
			return nil, fmt.Errorf("line %d: expected <nar-size>\\t<store-path>", lineNumber)
		}

		size, err := strconv.ParseUint(sizeText, 10, 64)
		if err != nil {
			return nil, fmt.Errorf("line %d: parse NAR size: %w", lineNumber, err)
		}

		entries = append(entries, Entry{
			Size: size,
			Path: path,
		})
	}
	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return entries, nil
}

func WritePathSizes(w io.Writer, entries []Entry) error {
	buffered := bufio.NewWriter(w)
	for _, entry := range entries {
		if _, err := fmt.Fprintf(buffered, "%d\t%s\n", entry.Size, entry.Path); err != nil {
			return err
		}
	}
	return buffered.Flush()
}

func WritePaths(w io.Writer, entries []Entry) error {
	buffered := bufio.NewWriter(w)
	for _, entry := range entries {
		if _, err := fmt.Fprintln(buffered, entry.Path); err != nil {
			return err
		}
	}
	return buffered.Flush()
}

func WriteSkippedPathSizes(w io.Writer, entries []SkippedEntry) error {
	buffered := bufio.NewWriter(w)
	for _, entry := range entries {
		if _, err := fmt.Fprintf(buffered, "%s\t%d\t%s\n", entry.Reason, entry.Entry.Size, entry.Entry.Path); err != nil {
			return err
		}
	}
	return buffered.Flush()
}
