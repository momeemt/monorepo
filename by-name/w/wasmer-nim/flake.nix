{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    fenix,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlays = [
          (_: super: let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs pkgs)
          (self: super: {
            emscripten = super.emscripten.override {
              llvmPackages = super.llvmPackages_17;
            };
            wasmer-capi = import ./nix/wasmer-capi.nix {
              inherit (super) stdenv lib fetchFromGitHub makeWrapper gnumake nodejs_20 pkg-config openssl libffi libiconv darwin;
              cargo = fenix.packages.${system}.complete.cargo;
              rustc = fenix.packages.${system}.complete.rustc;
            };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            nil
            alejandra
            treefmt
            nim-unwrapped-2
            nimble
            gcc
            emscripten
            wasmer
            wasmer-capi
          ];
          WASMER_C_API_DIR = "${pkgs.wasmer-capi}";
        };
      }
    );
}
