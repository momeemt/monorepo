{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
      inputs.nixpkgs-stable.follows = "nixpkgs";
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
        name = "myapp";
        version = "0.1.0";
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            (rust-bin.stable.latest.default.override {
              extensions = ["rust-src"];
            })
            rust-analyzer
          ];
          RUST_SRC_PATH = "${pkgs.rust-bin.stable.latest.default}/lib/rustlib/src/rust";
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
            rustfmt.enable = true;
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

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = name;
          inherit version;

          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;

          # If your project depends on the openssl crate, you need to add
          buildInputs = with pkgs; [
            openssl
            openssl.dev
          ];

          nativeBuildInputs = with pkgs; [
            pkgs-config
          ];
        };

        checks = {
          formatting = config.treefmt.build;

          clippy =
            pkgs.runCommand "clippy" {
              nativeBuildInputs = with pkgs; [
                (rust-bin.stable.latest.default.override {
                  extensions = ["rust-src"];
                })
              ];
            } ''
              export CARGO_HOME=$TMPDIR/cargo-home
              cargo clippy --workspace --all-targets -- -D warnings
              touch $out
            '';

          tests =
            pkgs.runCommand "tests" {
              nativeBuildInputs = with pkgs; [
                (rust-bin.stable.latest.default.override {
                  extensions = ["rust-src"];
                })
              ];
            } ''
              export CARGO_HOME=$TMPDIR/cargo-home
              cargo test --workspace --all-targets
              touch $out
            '';
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/${name}";
        };
      };
    };
}
