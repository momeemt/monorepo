#!/usr/bin/env bash
set -eu

# See <https://gist.github.com/lorenzleutgeb/239214f1d60b1cf8c79e7b0dc0483deb>.

# Will exit non-zero if not logged in.
gh auth status

if [ $# == 1 ]; then
  # Pass GitHub login name as commandline argument.
  LOGIN=$1
else
  # Default to currently logged in user.
  LOGIN=$(gh api user --jq .login)
fi

BASE="gh pr list --repo NixOS/nixpkgs --json id --jq length --limit 500"

MERGED=$($BASE --author "$LOGIN" --state merged)
REVIEWED=$($BASE --search "reviewed-by:$LOGIN -author:$LOGIN" --state all)

cat <<EOM
――――――――――
 - [$MERGED PRs merged](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Amerged+author%3A$LOGIN)
 - [$REVIEWED PRs reviewed](https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+reviewed-by%3A$LOGIN+-author%3A$LOGIN)
EOM
