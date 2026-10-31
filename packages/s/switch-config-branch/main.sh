# shellcheck disable=SC2148

set -euo pipefail

DATE="$(date "+%F")"
UUID="$(uuidgen)"
BRANCH_NAME="config/$DATE-$UUID"

git switch -c "$BRANCH_NAME"
