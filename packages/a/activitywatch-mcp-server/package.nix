{pkgs, ...}:
pkgs.buildNpmPackage {
  pname = "activitywatch-mcp-server";
  version = "1.1.0-unstable-2025-03-28";
  src = pkgs.fetchFromGitHub {
    owner = "8bitgentleman";
    repo = "activitywatch-mcp-server";
    rev = "86d7cf2717880b2483e935aaaa96653418d69848";
    hash = "sha256-dpTzhsXT0ciW8sLY59TdoInOeOeUZUDWaDc76qKyW/M=";
  };
  npmDepsHash = "sha256-/UJOM4fgzo1MffYFhJasz7wePtK8J+mcUtgA2Q1ozfg=";
  npmBuildScript = "build";
  doCheck = false;
}
