package plan

import "regexp"

const (
	SkipReasonNARSizeOverLimit = "nar-size-over-limit"
	SkipReasonExcludedByRegex  = "excluded-by-regex"
)

type Entry struct {
	Size uint64
	Path string
}

type SkippedEntry struct {
	Reason string
	Entry  Entry
}

type Options struct {
	MaxPathNARBytes uint64
	ExcludeStore    *regexp.Regexp
}

type Result struct {
	Upload  []Entry
	Skipped []SkippedEntry
}

func Build(entries []Entry, opts Options) Result {
	result := Result{
		Upload:  make([]Entry, 0, len(entries)),
		Skipped: make([]SkippedEntry, 0),
	}

	for _, entry := range entries {
		reason := skipReason(entry, opts)
		if reason != "" {
			result.Skipped = append(result.Skipped, SkippedEntry{
				Reason: reason,
				Entry:  entry,
			})
			continue
		}

		result.Upload = append(result.Upload, entry)
	}

	return result
}

func skipReason(entry Entry, opts Options) string {
	if opts.MaxPathNARBytes > 0 && entry.Size > opts.MaxPathNARBytes {
		return SkipReasonNARSizeOverLimit
	}
	if opts.ExcludeStore != nil && opts.ExcludeStore.MatchString(entry.Path) {
		return SkipReasonExcludedByRegex
	}
	return ""
}
