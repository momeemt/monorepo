{
  description = "SATySFi slides template for presentations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    satyxin.url = "github:SnO2WMaN/satyxin";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    systems.url = "github:nix-systems/default";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk.url = "github:nix-community/naersk";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = with inputs; [
        treefmt-nix.flakeModule
        pre-commit-hooks-nix.flakeModule
      ];

      systems = import inputs.systems;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
            inputs.satyxin.overlays.default
          ];
        };

        devShells.default = let
          naersk' = pkgs.callPackage inputs.naersk {};
          satysfi-language-server = naersk'.buildPackage {
            src = pkgs.fetchFromGitHub {
              owner = "monaqa";
              repo = "satysfi-language-server";
              rev = "1ce6bc4d08eb748aeb10f69498e4a16f01978535";
              sha256 = "sha256-4EmLDsCrJXzQb72JrGGPR7+gAQKcniVGrBnrl9JanBs=";
            };
          };
          satysfi-formatter = naersk'.buildPackage {
            src = pkgs.fetchFromGitHub {
              owner = "usagrada";
              repo = "satysfi-formatter";
              rev = "7d25b29e7b8a35bbbf0d64add333a9cc1f2fe541";
              hash = "sha256-eUSssSFcCJ6HAvccn/wGHU58uiNOJnaBBQW4exOyUys=";
            };
          };
        in
          pkgs.mkShell {
            buildInputs = with pkgs; [
              nil
              ocamlPackages.ocaml-lsp
              satysfi
              satysfi-formatter
              satysfi-language-server
            ];
          };

        packages = rec {
          satysfiDist = pkgs.satyxin.buildSatysfiDist {
            packages = with pkgs.satyxinPackages; [
              class-slydifi
            ];
          };

          default = pkgs.satyxin.buildDocument {
            inherit satysfiDist;
            name = "main";
            src = ./src;
            entrypoint = "main.saty";
          };
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
            ocamlformat.enable = true;
          };
          settings = {
            formatter = {
              "satysfi-formatter" = {
                command = "satysfi-fmt";
                options = [
                  "-w"
                ];
                includes = [
                  "*.saty"
                ];
              };
            };
          };
        };

        pre-commit = {
          check.enable = true;
          settings = {
            hooks = {
              treefmt.enable = true;
            };
          };
        };

        checks = {
          formatting = config.treefmt.build;
        };
      };
    };
}
