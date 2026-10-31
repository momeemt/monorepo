{pkgs, ...}:
pkgs.writeShellApplication {
  name = "switch-config-branch";
  runtimeInputs = with pkgs; [
    util-linux
    coreutils
    git
  ];
  text = builtins.readFile ./main.sh;
}
