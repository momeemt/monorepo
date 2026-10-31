{
  pkgs,
  inputsFrom,
}:
pkgs.mkShell {
  inherit inputsFrom;
  buildInputs = with pkgs; [
    nodejs-slim
  ];
}
