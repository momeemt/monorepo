{pkgs}: let
  inherit (pkgs) lib stdenvNoCC;

  spagoConfig = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./packages.dhall
      ./spago.dhall
    ];
  };

  spagoDeps = stdenvNoCC.mkDerivation {
    pname = "portfolio-spago-deps";
    version = "unstable-2026-05-30";

    src = spagoConfig;

    nativeBuildInputs = with pkgs; [
      cacert
      dhall
      git
      spago
    ];

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-x6cKTw0D/9kSMq8wzRoRZ22ImOcBBVONlSVoZS1iCYY=";

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR"
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIT_SSL_CAINFO="$SSL_CERT_FILE"

      dhall resolve --file packages.dhall > packages.dhall.resolved
      spago install
      find .spago -name .git -type d -prune -exec rm -rf {} +

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R .spago "$out"/.spago
      cp packages.dhall.resolved "$out"/packages.dhall

      runHook postInstall
    '';
  };

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./packages.dhall
      ./public
      ./spago.dhall
      ./src
      ./tailwind.config.js
      ./test
    ];
  };
in
  stdenvNoCC.mkDerivation {
    pname = "portfolio";
    version = "unstable-2026-05-30";

    inherit src;

    nativeBuildInputs = with pkgs; [
      cacert
      dhall
      esbuild
      git
      purescript
      spago
      tailwindcss
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR"
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIT_SSL_CAINFO="$SSL_CERT_FILE"

      cp -R ${spagoDeps}/.spago .spago
      cp ${spagoDeps}/packages.dhall packages.dhall
      chmod -R u+rwX .spago

      spago bundle-app --no-install -y -t ./public/index.js
      tailwindcss -i ./src/index.css -o ./public/index.css

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R public/. "$out"/

      runHook postInstall
    '';

    meta = {
      description = "Static portfolio site for momee.mt";
      homepage = "https://momee.mt";
      license = with lib.licenses; [asl20 mit];
    };
  }
