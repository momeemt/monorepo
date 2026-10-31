{inputs, ...}: {
  perSystem = {
    pkgs,
    pkgs-25_05,
    config,
    system,
    ...
  }: let
    inputsFrom = with config; [
      treefmt.build.devShell
      just-flake.outputs.devShell
      pre-commit.devShell
    ];
    importPackage = path:
      import path {
        inherit pkgs inputsFrom;
      };
  in {
    devShells = {
      default = pkgs.mkShell {
        inherit inputsFrom;
        buildInputs = with pkgs; [
          # config.files.writer.drv
          sops
          inputs.nur-packages.legacyPackages.${system}.aicommit
          encrypt-secrets
          updatekeys-secrets
          destroy-all-vm
          switch-config-branch
        ];
      };
      growth = import ../../assets/growth/devShell.nix {
        pkgs = pkgs-25_05;
        inherit inputsFrom;
      };
      terraform = importPackage ../../terraform/devShell.nix;
      k8s = importPackage ../../k8s/devShell.nix;

      # packages/**
      attic-pack = importPackage ../../packages/a/attic-pack/devShell.nix;
      blog = importPackage ../../packages/b/blog/devShell.nix;
      monorepo-docs = importPackage ../../packages/m/monorepo-docs/devShell.nix;
      obsidian = importPackage ../../packages/o/obsidian/devShell.nix;
      portfolio = import ../../packages/p/portfolio/devShell.nix {
        inherit pkgs inputsFrom;
      };
      slides = importPackage ../../packages/s/slides/devShell.nix;
    };
  };
}
