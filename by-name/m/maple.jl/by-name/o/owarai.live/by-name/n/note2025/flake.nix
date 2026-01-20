{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
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

      systems = import inputs.systems;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        mdbook-numthm = pkgs.rustPlatform.buildRustPackage rec {
          pname = "mdbook-numthm";
          version = "0.2.0";

          src = pkgs.fetchFromGitHub {
            owner = "momeemt";
            repo = "mdbook-numthm";
            rev = "21f54ee53a783f61af6a4221fa0462043a1c4367";
            hash = "sha256-P6XmvnuWt/dQ+ZkXfM949ARryaUpHNEQg624IsD0b3g=";
          };

          useFetchCargoVendor = true;
          cargoHash = "sha256-UyzCdrhNkDNRM95Y/iEpWUoFLBoe7BBvORJFbId4hEk=";
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            mdbook
            mdbook-katex
            mdbook-admonish
            mdbook-numthm
          ];
        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "note.momee.mt";
          version = "2025/07/02";

          src = builtins.path {
            path = ./.;
            name = "source";
          };

          buildPhase = ''
            mdbook build
          '';

          installPhase = ''
            mkdir -p $out
            mv ./book $out/book
          '';

          buildInputs = with pkgs; [
            mdbook
            mdbook-katex
            mdbook-admonish
            mdbook-numthm
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
          };
        };
      };
    };
}
