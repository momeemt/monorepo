{pkgs, ...}:
pkgs.writeShellApplication {
  name = "quitapp";
  text = ''
    if ! command -v osascript >/dev/null 2>&1; then
      echo "Error: osascript not found. This command only works on macOS."
      exit 1
    fi
    exec /usr/bin/osascript "${./main.applescript}"
  '';
}
