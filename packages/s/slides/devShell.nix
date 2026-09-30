{
  pkgs,
  inputsFrom,
}: let
  typst-packages = with pkgs.typstPackages; [
    codelst
    h-graph
    finite
  ];
in
  pkgs.mkShell {
    inherit inputsFrom;
    buildInputs = with pkgs;
      [
        typst
        just
        sops
      ]
      ++ typst-packages;
  }
