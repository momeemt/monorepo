{ pkgs ? import ./nix/pkgs.nix }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    python311
    python311Packages.numpy
    python311Packages.shapely
    python311Packages.opencv4
  ];
}
