{
  pkgs,
  inputsFrom,
}: let
  inherit (pkgs) lib stdenv;
in
  pkgs.mkShell {
    inherit inputsFrom;

    buildInputs = with pkgs;
      [
        nil
        alejandra
        purescript
        spago
        dhall
        dhall-lsp-server
        nodejs_22
        esbuild
        tailwindcss
      ]
      ++ lib.optional (pkgs ? purescript-language-server) pkgs.purescript-language-server
      ++ lib.optional (pkgs ? purs-tidy) pkgs.purs-tidy
      ++ lib.optionals stdenv.isDarwin [
        apple-sdk
      ];
  }
