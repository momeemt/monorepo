{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
            python311
            ruff
            python311Packages.numpy
            python311Packages.matplotlib
            python311Packages.scipy
            python311Packages.scikit-learn
            python311Packages.fastdtw
          ];
        };
      }
    );
}
