{pkgs, ...}: let
  text = path: ''
    if ! command -v osascript >/dev/null 2>&1; then
      echo "Error: osascript not found. This command only works on macOS."
      exit 1
    fi
    exec /usr/bin/osascript "${path}" "$@"
  '';
  platforms = [
    "aarch64-darwin"
    "x86_64-darwin"
  ];
in rec {
  ok = pkgs.writeShellApplication {
    name = "ok";
    text = text ./ok.applescript;
    meta.platforms = platforms;
  };

  ng = pkgs.writeShellApplication {
    name = "ng";
    text = text ./ng.applescript;
    meta.platforms = platforms;
  };

  subscribe = pkgs.writeShellApplication {
    name = "subscribe";
    text = ''
      if "$@"; then
        ${ok}/bin/ok "$@"
      else
        ${ng}/bin/ng "$@"
      fi
    '';
    meta.platforms = platforms;
  };
}
