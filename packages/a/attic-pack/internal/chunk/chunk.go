package chunk

import "github.com/momeemt/monorepo/packages/attic-pack/internal/plan"

type Chunk struct {
	Index uint
	Bytes uint64
	Paths []string
}

type Options struct {
	TargetBytes uint64
}

func Build(entries []plan.Entry, opts Options) []Chunk {
	var chunks []Chunk
	current := Chunk{Index: 1}

	for _, entry := range entries {
		if len(current.Paths) > 0 && opts.TargetBytes > 0 && current.Bytes+entry.Size > opts.TargetBytes {
			chunks = append(chunks, current)
			current = Chunk{Index: current.Index + 1}
		}

		current.Bytes += entry.Size
		current.Paths = append(current.Paths, entry.Path)
	}

	if len(current.Paths) > 0 {
		chunks = append(chunks, current)
	}

	return chunks
}
