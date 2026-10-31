# shellcheck disable=SC2148

set -euo pipefail

HOST_NAME=$(uname -n)
FLAKE_ROOT="."

NIX_FLAGS=()
if [ -n "${SHOWTRACE:-}" ]; then
  NIX_FLAGS+=(--show-trace)
fi
if [ -n "${DEV:-}" ]; then
  NIX_FLAGS+=(--override-input tmux-nix path:./nix/flakes/tmux-nix)
fi
if [ "$HOST_NAME" = "uguisu" ]; then
  NIX_FLAGS+=(--experimental-features "nix-command flakes")
fi

echo "[apply.sh] NIX_FLAGS: ${NIX_FLAGS[*]}"

case $HOST_NAME in
uguisu)
  sudo nix run "nix-darwin/master#darwin-rebuild" -- \
    switch --flake "$FLAKE_ROOT#$HOST_NAME"
  ;;
emu | shime)
  sudo env NIX_CONFIG='experimental-features = nix-command flakes pipe-operators' \
    nixos-rebuild switch \
    --flake "$FLAKE_ROOT#$HOST_NAME" \
    "${NIX_FLAGS[@]}"
  ;;
*)
  echo "Unknown host: $HOST_NAME"
  exit 1
  ;;
esac
