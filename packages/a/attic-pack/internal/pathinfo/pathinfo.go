package pathinfo

import (
	"encoding/json"
	"io"
	"sort"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

type jsonPathInfo struct {
	NARSize uint64 `json:"narSize"`
}

func Read(r io.Reader) ([]plan.Entry, error) {
	var pathInfo map[string]jsonPathInfo
	if err := json.NewDecoder(r).Decode(&pathInfo); err != nil {
		return nil, err
	}

	entries := make([]plan.Entry, 0, len(pathInfo))
	for path, info := range pathInfo {
		entries = append(entries, plan.Entry{
			Size: info.NARSize,
			Path: path,
		})
	}

	return entries, nil
}

func Normalize(entries []plan.Entry) []plan.Entry {
	byPath := make(map[string]uint64, len(entries))
	for _, entry := range entries {
		size, ok := byPath[entry.Path]
		if !ok || entry.Size > size {
			byPath[entry.Path] = entry.Size
		}
	}

	normalized := make([]plan.Entry, 0, len(byPath))
	for path, size := range byPath {
		normalized = append(normalized, plan.Entry{
			Size: size,
			Path: path,
		})
	}

	sort.Slice(normalized, func(i, j int) bool {
		if normalized[i].Size != normalized[j].Size {
			return normalized[i].Size < normalized[j].Size
		}
		return normalized[i].Path < normalized[j].Path
	})

	return normalized
}
