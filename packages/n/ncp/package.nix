{pkgs, ...}:
pkgs.writeShellApplication {
  name = "ncp";
  runtimeInputs = with pkgs; [
    gh
    jq
  ];
  text = builtins.readFile ./main.sh;
}
