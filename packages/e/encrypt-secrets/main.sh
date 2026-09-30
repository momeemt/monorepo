# shellcheck disable=SC2148

set -euo pipefail

ROOT_DIR="$(pwd)"
SECRETS_DIR="$ROOT_DIR/secrets"
TARGETS=$(find "$SECRETS_DIR" -type f ! -regex '.*\.enc\..*' ! -path '*/.git/*' ! -name '.gitignore')

echo "[encrypt-secrets] Encrypting secrets in: $SECRETS_DIR"
for file in $TARGETS; do
  ext="${file##*.}"
  stem="${file%.*}"
  ENC_FILE="${stem}.enc.${ext}"
  echo "  - encrypting: $file -> $ENC_FILE"
  sops -e "$file" >"$ENC_FILE"
done
echo "[encrypt-secrets] All secrets encrypted!"
