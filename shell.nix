{ pkgs ? import ./nix/pkgs.nix }:
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    python310
    python310Packages.numpy
    python310Packages.shapely
    python310Packages.opencv4
    python310Packages.torch
    python310Packages.torchvision
  ];
}
