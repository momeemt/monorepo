# shellcheck disable=SC2148

set -euo pipefail

ROOT_DIR="$(pwd)"
SECRETS_DIR="$ROOT_DIR/secrets"
TARGETS=$(find "$SECRETS_DIR" -type f -regex '.*\.enc\..*')

echo "[updatekeys-secrets] Updating secrets in: $SECRETS_DIR"
for file in $TARGETS; do
  echo "  - updating: $file"
  sops updatekeys "$file"
done
echo "[updatekeys-secrets] All secrets updated!"
