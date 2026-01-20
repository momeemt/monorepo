{
  description = "Google Form to Todo-app Task";

  inputs = {
    nixpkgs = {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "ce35e61c3cc608d0f7c4a5ed96f7fb3c19211884";
      type = "github";
    };
    flake-utils = {
      owner = "numtide";
      repo = "flake-utils";
      rev = "93a2b84fc4b70d9e089d029deacc3583435c2ed6";
      type = "github";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs;
        google-clasp = pkgs.google-clasp;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            nodejs
            google-clasp
          ];
        };
      }
    );
}