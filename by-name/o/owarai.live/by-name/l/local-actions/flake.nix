{
  description = "Run workflow on your local!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import rust-overlay)
          ];
        };
        toolchain = pkgs.rust-bin.stable.latest.default;
        rustPlatform = pkgs.makeRustPlatform {
          rustc = toolchain;
          cargo = toolchain;
        };
        name = "local-actions";
      in {
        packages.default = rustPlatform.buildRustPackage {
          inherit name;
          version = "0.0.1";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        apps.${system}.default = {
          type = "app";
          program = "${self.packages.${system}.${name}}/bin/${name}";
        };

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            toolchain
            rust-analyzer
            nil
            alejandra
          ];
        };
      }
    );
}
