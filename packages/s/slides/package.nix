{pkgs}: let
  inherit (pkgs) lib stdenvNoCC;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./public
      ./templates
      ./web/generate-index.py
    ];
  };

  typst-packages = with pkgs.typstPackages; [
    codelst
    h-graph
    finite
  ];
  typstPackagePath = lib.makeSearchPath "lib/typst-packages" (lib.closePropagation typst-packages);
  typstFontPaths = lib.makeSearchPath "share/fonts" [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
  ];
in
  stdenvNoCC.mkDerivation {
    pname = "slides";
    version = "unstable-2026-05-18";

    inherit src;

    nativeBuildInputs = with pkgs;
      [
        python3
        typst
      ]
      ++ typst-packages;

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export TYPST_FONT_PATHS="${typstFontPaths}"
      export TYPST_PACKAGE_PATH="${typstPackagePath}"
      export TYPST_PACKAGE_CACHE_PATH="$TMPDIR/typst-package-cache"

      mkdir -p dist/thumbnails
      mkdir -p "$TYPST_PACKAGE_CACHE_PATH"

      shopt -s nullglob
      for dir in public/*/; do
        if [ -f "$dir/main.typ" ]; then
          name="$(basename "$dir")"

          typst compile "$dir/main.typ" "dist/$name.pdf" --root .
          typst compile "$dir/main.typ" "dist/thumbnails/$name.png" --root . --format png --pages 1
        fi
      done

      python3 web/generate-index.py \
        --public-dir public \
        --dist-dir dist \
        --site-url https://slides.momee.mt

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R dist/. "$out"/

      runHook postInstall
    '';

    meta = {
      description = "Static site for momeemt presentation slides";
      homepage = "https://slides.momee.mt";
      license = lib.licenses.asl20;
    };
  }
