#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
PRIVATE_DIR="$ROOT_DIR/private"

if [ ! -d "$PRIVATE_DIR" ]; then
  echo "Private directory not found: $PRIVATE_DIR"
  exit 1
fi

echo "Encrypting private dirs under: $PRIVATE_DIR"

found=0
for dir in "$PRIVATE_DIR"/*; do
  [ -d "$dir" ] || continue
  [ -f "$dir/.sops.yaml" ] || continue

  found=1
  echo "  - dir: $dir"

  (
    cd "$dir"

    while IFS= read -r -d '' rel; do
      rel="${rel#./}"
      base="$(basename "$rel")"

      case "$base" in
      .sops.yaml | .gitignore | *.enc.* | *.enc | *.pdf | *.PDF) continue ;;
      esac

      if printf '%s' "$base" | grep -q '\.'; then
        stem="${base%.*}"
        ext="${base##*.}"
        enc_base="${stem}.enc.${ext}"
      else
        enc_base="${base}.enc"
      fi

      rel_dir="$(dirname "$rel")"
      if [ "$rel_dir" = "." ]; then
        enc_rel="$enc_base"
      else
        enc_rel="$rel_dir/$enc_base"
      fi

      if [ -f "$enc_rel" ] && [ "$enc_rel" -nt "$rel" ]; then
        continue
      fi

      echo "    - $rel -> $enc_rel"
      sops -e "$rel" >"$enc_rel"
    done < <(
      find . -type f \
        ! -path '*/.git/*' \
        ! -name '*.enc.*' \
        ! -name '*.pdf' \
        ! -name '.sops.yaml' \
        ! -name '.gitignore' \
        -print0
    )
  )
done

if [ $found -eq 0 ]; then
  echo "No private dirs with .sops.yaml found under: $PRIVATE_DIR" >&2
  exit 1
fi

echo "Encryption completed."
