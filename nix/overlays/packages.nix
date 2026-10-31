_final: prev: let
  pkgs = prev;
  importPackage = name: let
    firstLetter = builtins.substring 0 1 name;
  in
    import ../../packages/${firstLetter}/${name}/package.nix {inherit pkgs;};
  subscribePackages = importPackage "subscribe";
in {
  activitywatch-mcp-server = importPackage "activitywatch-mcp-server";
  attic-pack = importPackage "attic-pack";
  blog = importPackage "blog";
  bluesky-mcp = importPackage "bluesky-mcp";
  destroy-all-vm = importPackage "destroy-all-vm";
  encrypt-secrets = importPackage "encrypt-secrets";
  karabiner-elements_14-13-0 = importPackage "karabiner-elements_14-13-0";
  ncp = importPackage "ncp";
  obsidian = importPackage "obsidian";
  portfolio = importPackage "portfolio";
  quitapp = importPackage "quitapp";
  slides = importPackage "slides";
  switch-config-branch = importPackage "switch-config-branch";
  updatekeys-secrets = importPackage "updatekeys-secrets";
  xdg-compliance-checker = importPackage "xdg-compliance-checker";

  inherit (subscribePackages) ok ng subscribe;
}
