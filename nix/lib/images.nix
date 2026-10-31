{pkgs, ...}: {
  ubuntu-lts = pkgs.fetchurl {
    url = "https://cloud-images.ubuntu.com/releases/noble/release-20260321/ubuntu-24.04-server-cloudimg-amd64.img";
    hash = "sha256-XD3bAPYLxFXawIYvq+nYus7EbDOsF1EUPFw2g0BLEQ0=";
  };
}
