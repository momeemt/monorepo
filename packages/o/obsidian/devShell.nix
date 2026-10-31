{
  pkgs,
  inputsFrom,
}:
pkgs.mkShell {
  inherit inputsFrom;
  buildInputs = with pkgs; [
    git
    nodejs_22
    rsync
  ];
}
