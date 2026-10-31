{pkgs, ...}:
pkgs.writeShellApplication {
  name = "destroy-all-vm";
  runtimeInputs = with pkgs; [
    libvirt
  ];
  text = builtins.readFile ./main.sh;
}
