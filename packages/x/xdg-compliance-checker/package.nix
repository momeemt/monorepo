{pkgs, ...}:
pkgs.writeShellApplication {
  name = "xdg-compliance-checker";
  text = builtins.readFile ./main.sh;
}
