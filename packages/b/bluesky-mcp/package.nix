{pkgs, ...}:
pkgs.buildNpmPackage {
  pname = "bluesky-mcp";
  version = "0-unstable-2025-01-26";
  src = pkgs.fetchFromGitHub {
    owner = "momeemt";
    repo = "bluesky-mcp";
    rev = "c4a17f1";
    hash = "sha256-X2eDToHqV70N1HpcnriUzxHQQHWnLxNMIXsM6rq/BEo=";
  };
  npmDepsHash = "sha256-0G8pDdjpJju8UgQ63OJkrmEybJylj9r2gMaspHZFthg=";
  nodejs = pkgs.nodejs_24;
  doCheck = false;
  npmBuildScript = "build";
  postBuild = ''
    cp -r dist $TMPDIR/dist
  '';
  postInstall = ''
    cp -r $TMPDIR/dist $out/lib/node_modules/@semihberkay/bluesky-mcp/
  '';
}
