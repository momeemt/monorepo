_: {
  perSystem = {pkgs, ...}: {
    packages = {
      attic-pack = import ../../packages/a/attic-pack/package.nix {
        inherit pkgs;
      };
      blog = import ../../packages/b/blog/package.nix {
        inherit pkgs;
      };
      obsidian = import ../../packages/o/obsidian/package.nix {
        inherit pkgs;
      };
      portfolio = import ../../packages/p/portfolio/package.nix {
        inherit pkgs;
      };
      slides = import ../../packages/s/slides/package.nix {
        inherit pkgs;
      };
    };
  };
}
