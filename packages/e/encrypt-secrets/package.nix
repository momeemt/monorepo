{pkgs, ...}:
pkgs.writeShellApplication {
  name = "encrypt-secrets";
  runtimeInputs = with pkgs; [
    sops
    findutils
    coreutils
  ];
  text = builtins.readFile ./main.sh;
}
