let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/48269da3158b02e6314ec6756333301311d9b759.tar.gz";
    sha256 = "17gg7bdg5s6h9ffh99czwrk3fyp0si047dcbgi39l2hg980fzp92";
  };
in
import nixpkgs {}
