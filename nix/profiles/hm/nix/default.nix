{
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings =
      {
        accept-flake-config = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        extra-substituters = [
          "https://cache.numtide.com"
        ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
        sandbox = true;
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        sandbox = true;
      };
    checkConfig = true;
    # NOTE: nh.clean.enable = true
    # gc = {
    #   automatic = true;
    # };
  };
}
