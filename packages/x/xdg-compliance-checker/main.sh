# shellcheck disable=SC2148

set -euo pipefail

HOME_DIR="${HOME}"

if [ "${NO_COLOR-}" != "" ]; then
  C_GREEN=""
  C_RED=""
  C_GRAY=""
  C_RESET=""
else
  C_GREEN="\033[32m"
  C_RED="\033[31m"
  C_GRAY="\033[90m"
  C_RESET="\033[0m"
fi

contains() {
  local needle="$1"
  shift
  local x
  for x in "$@"; do
    [ "$x" = "$needle" ] && return 0
  done
  return 1
}

read_list_file() {
  local path="$1"
  local line

  [ -f "$path" ] || return 0

  while IFS= read -r line; do
    line="${line%%$'\r'}"
    case "$line" in
    '' | \#*) continue ;;
    *) printf '%s\n' "$line" ;;
    esac
  done <"$path"
}

basename_if_under_home() {
  local var="$1"
  local val
  val="${!var-}"
  [ -z "${val}" ] && return 1

  case "$val" in
  "$HOME_DIR"/*)
    local rel="${val#"$HOME_DIR"/}"
    local first="${rel%%/*}"
    [ -n "$first" ] && printf '%s\n' "$first"
    ;;
  *)
    return 1
    ;;
  esac
}

GREEN_LIST=(
  ".config"
  ".cache"
  ".local"
  "Applications"
  "Desktop"
  "Documents"
  "Downloads"
  "Library"
  "Movies"
  "Music"
  "Pictures"
  "Public"
  "Videos"
)

for var in XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME; do
  name="$(basename_if_under_home "$var")"
  if [ -n "${name-}" ] && ! contains "$name" "${GREEN_LIST[@]}"; then
    GREEN_LIST+=("$name")
  fi
done

if [ -n "${XDG_CONFIG_HOME-}" ]; then
  CONFIG_HOME="$XDG_CONFIG_HOME"
else
  CONFIG_HOME="$HOME_DIR/.config"
fi
CHECKER_CONFIG_DIR="${CONFIG_HOME}/xdg-home-checker"

GREENLIST_FILE="${CHECKER_CONFIG_DIR}/greenlist.txt"
GRAYLIST_FILE="${CHECKER_CONFIG_DIR}/graylist.txt"

if [ -f "$GREENLIST_FILE" ]; then
  while IFS= read -r name; do
    [ -z "$name" ] && continue
    if ! contains "$name" "${GREEN_LIST[@]}"; then
      GREEN_LIST+=("$name")
    fi
  done < <(read_list_file "$GREENLIST_FILE")
fi

GRAY_LIST=(
  ".DS_Store"
  ".ssh"
  ".Trash"
  ".CFUserTextEncoding"
  ".IdentityService"
  "nix"
  ".nix-defexpr"
  ".nix-profile"
  ".bash_sessions"
  # https://github.com/apple/cups
  ".cups"
)

if [ -f "$GRAYLIST_FILE" ]; then
  while IFS= read -r name; do
    [ -z "$name" ] && continue
    GRAY_LIST+=("$name")
  done < <(read_list_file "$GRAYLIST_FILE")
fi

entries=()

for path in "$HOME_DIR"/*; do
  [ -e "$path" ] || continue
  entries+=("$path")
done

for path in "$HOME_DIR"/.[!.]* "$HOME_DIR"/..?*; do
  [ -e "$path" ] || continue
  entries+=("$path")
done

SEEN_NAMES=()

green_count=0
gray_count=0
red_count=0
total_count=0

for path in "${entries[@]}"; do
  name="$(basename "$path")"

  if contains "$name" "${SEEN_NAMES[@]}"; then
    continue
  fi
  SEEN_NAMES+=("$name")
  total_count=$((total_count + 1))

  if [ -L "$path" ]; then
    target="$(readlink "$path")"
    case "$target" in
    /nix/store/*)
      printf '%b[SKIP]     %s -> %s%b\n' "$C_GRAY" "$name" "$target" "$C_RESET"
      gray_count=$((gray_count + 1))
      continue
      ;;
    esac
  fi

  if contains "$name" "${GREEN_LIST[@]}"; then
    printf '%b[OK]       %s%b\n' "$C_GREEN" "$name" "$C_RESET"
    green_count=$((green_count + 1))
  elif contains "$name" "${GRAY_LIST[@]}"; then
    printf '%b[SKIP]     %s%b\n' "$C_GRAY" "$name" "$C_RESET"
    gray_count=$((gray_count + 1))
  else
    printf '%b[DETECTED] %s%b\n' "$C_RED" "$name" "$C_RESET"
    red_count=$((red_count + 1))
  fi
done

printf '\n Summary:\n'
printf '  %bOK%b        : %d\n' "$C_GREEN" "$C_RESET" "$green_count"
printf '  %bSKIP%b      : %d\n' "$C_GRAY" "$C_RESET" "$gray_count"
printf '  %bDETECTED%b  : %d\n' "$C_RED" "$C_RESET" "$red_count"
printf '  Total     : %d\n' "$total_count"

exit "$red_count"
