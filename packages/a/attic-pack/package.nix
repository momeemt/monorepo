{pkgs}: let
  inherit (pkgs) lib;

  pname = "attic-pack";
in
  pkgs.buildGoModule {
    inherit pname;

    version = "0.1.0";

    src = lib.fileset.toSource {
      root = ./.;
      fileset =
        lib.fileset.difference
        ./.
        (lib.fileset.unions [
          ./devShell.nix
          ./package.nix
          (lib.fileset.maybeMissing ./.direnv)
          (lib.fileset.maybeMissing ./.git)
          (lib.fileset.maybeMissing ./result)
        ]);
    };

    vendorHash = null;

    ldflags = [
      "-s"
      "-w"
    ];

    meta = {
      description = "Prepare Nix store paths for Attic pushes";
      license = lib.licenses.asl20;
      mainProgram = pname;
    };
  }
