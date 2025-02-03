{
  description = "The experimental programming language";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    mini-compile-commands = {
      url = "github:danielbarter/mini_compile_commands";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    mini-compile-commands,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        mccEnv = (pkgs.callPackage mini-compile-commands {}).wrap pkgs.clangStdenv;
        mccShell = pkgs.mkShell.override {stdenv = mccEnv;};
      in {
        devShell = mccShell {
          name = "Rin";
          buildInputs = with pkgs; [
            clang-tools
            nil
            alejandra
            poac
          ];
        };
      }
    );
}
