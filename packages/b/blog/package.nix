{
  pkgs,
  site ? "https://blog.momee.mt",
}: let
  inherit (pkgs) lib;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./astro.config.mjs
      ./package-lock.json
      ./package.json
      ./public
      ./src
      ./tsconfig.json
    ];
  };
in
  pkgs.buildNpmPackage {
    pname = "blog";
    version = "unstable-2026-05-29";

    inherit src;

    npmDepsHash = "sha256-Oi1pYNwy8ADvKzIy9EJv0GTFcBSzinMVi8Tt2xnIGHM=";
    nodejs = pkgs.nodejs_24;

    BLOG_SITE = lib.removeSuffix "/" site;

    npmBuildScript = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R dist/. "$out"/

      runHook postInstall
    '';

    meta = {
      description = "Astro static blog for blog.momee.mt";
      homepage = "https://blog.momee.mt";
      license = lib.licenses.mit;
    };
  }
