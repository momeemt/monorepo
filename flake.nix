{
  description = "Ocaml WebAssembly toolings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        frameworks = pkgs.darwin.apple_sdk.frameworks;
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              nil
              alejandra
              opam
              ocamlPackages.ocaml
              ocamlPackages.dune_3
              ocamlPackages.ocaml-lsp
              ocamlPackages.batteries
              ocamlPackages.alcotest
              ocamlPackages.findlib
              ocamlformat
              wabt
              wasmtime
              wasmer
            ]
            ++ lib.optional stdenv.isDarwin [
              frameworks.Security
              frameworks.CoreFoundation
              frameworks.CoreServices
            ];
          shellHook = ''
            eval $(opam env)
          '';
        };
      }
    );
}
