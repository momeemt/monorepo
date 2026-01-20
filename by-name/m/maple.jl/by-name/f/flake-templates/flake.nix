{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = with inputs; [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake.templates = {
        rust = {
          path = ./rust;
          description = "Usual Rust project Template (cargo, rust-analyzer, treefmt, ghactions and flakes)";
        };
      };

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
          ];
          packages = [self'.packages.ft];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
          };
          settings.global.excludes = [
            "LICENSE-*"
          ];
        };

        packages.ft = pkgs.writeShellScriptBin "ft" ''
          set -euo pipefail
          if [ $# -eq 0 ]; then
            echo "Usage: ft <template> [nix flake init options...]" >&2
            exit 1
          fi
          template=$1
          shift
          nix flake init --template "github:momeemt/flake-templates#$template" "$@"
        '';

        packages.default = self'.packages.ft;
        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/ft";
        };
      };
    };
}
