{
  description = "Senpai with a complete understanding of computer science";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      }: let
        pname = "senpai";
        version = "0.0.1";
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [
            config.treefmt.build.devShell
            config.pre-commit.devShell
          ];

          buildInputs = with pkgs; [
            nil
            go
            gopls # Language Server for Go
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            gofumpt.enable = true;
            goimports.enable = true;
            golines.enable = true;
            mdformat.enable = true;
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

        packages.default = pkgs.buildGoModule {
          inherit pname version;
          src = builtins.path {
            path = ./.;
            name = "source";
          };
          vendorHash = "sha256-xff/2Dgv3PjsjB/Uf0GLL32M7NwJ1bAwwusnxlOdDJQ=";
          CGO_ENABLED = 0;
          ldflags = ["-s" "-w"];
        };

        checks = {
          formatting = config.treefmt.build;
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/${pname}";
        };
      };
    };
}
