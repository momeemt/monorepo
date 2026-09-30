{
  config,
  lib,
  pkgs,
  siteLib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.site.home;
  h = config.home.homeDirectory;
  inherit (config.xdg) dataHome configHome cacheHome;
in {
  options.site.home = {
    username = mkOption {
      type = types.str;
      description = "The user's username";
    };

    extraSessionPath = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of paths to be added to `home.sessionPath`";
    };

    extraSessionVariables = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Environment variables that are merged into `home.sessionVariables`";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Arbitrary extra packages to append to `home.packages`.";
    };

    extraDarwinCasks = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra GUI apps on Darwin. Ignored on Linux.";
    };

    groups = {
      linuxDesktop = mkEnableOption "Install common Linux desktop applications";
      darwinCasks = mkEnableOption "Install Homebrew casks and other macOS-specific GUI applications";
    };
  };

  config = {
    home = let
      basePackages = with pkgs;
        [
          fastfetch
          ghq
          nixpkgs-review
          gnumake
          yazi
          yq
          sops
          age
          cloudflared
          todoist
          usbutils
          nim
          docker-client
          cloc
          nodejs_24
          jupyter-all
          obsidian
          ncp
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          quitapp
          ok
          ng
          subscribe
          xdg-compliance-checker
          mas
        ];

      linuxDesktopPackages = with pkgs; [
        google-chrome
        spotify
        teams-for-linux # lab
        discord
        vesktop
        wl-clipboard
        gnome-screenshot
        todoist-electron
        mpv
      ];

      darwinCasks = import ./casks.nix {inherit pkgs lib;};

      combined =
        basePackages
        ++ (lib.optionals cfg.groups.linuxDesktop linuxDesktopPackages)
        ++ (lib.optionals cfg.groups.darwinCasks darwinCasks)
        ++ cfg.extraPackages
        ++ cfg.extraDarwinCasks;

      final = lib.unique combined;
    in {
      enableNixpkgsReleaseCheck = true;
      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/${cfg.username}"
        else "/Users/${cfg.username}";
      inherit (cfg) username;
      preferXdgDirectories = true;

      sessionVariables =
        {
          EDITOR = "nvim";
          VISUAL = "nvim";
          LANG = "ja_JP.UTF-8";
          PAGER = "less";
          MANPAGER = "less";
          XDG_CONFIG_HOME = "${h}/.config";
          XDG_CACHE_HOME = "${h}/.cache";
          XDG_DATA_HOME = "${h}/.local/share";
          XDG_STATE_HOME = "${h}/.local/state";
          SATYROGRAPHOS_EXPERIMENTAL = "1";
          AZURE_CONFIG_DIR = "${configHome}/azure";
          NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
          NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
          GHQ_ROOT = "${dataHome}/ghq";
          WASMER_DIR = "${dataHome}/wasmer";
          OPAMROOT = "${dataHome}/opam";
          IPYTHONDIR = "${configHome}/jupyter";
          JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
          JULIA_DEPOT_PATH = "${dataHome}/julia:$JULIA_DEPOT_PATH";
          ELM_HOME = "${configHome}/elm";
          CODEX_HOME = "${configHome}/codex";
          NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
          GEM_HOME = "${dataHome}/gem";
          GEM_SPEC_CACHE = "${cacheHome}/gem";
          GRADLE_USER_HOME = "${dataHome}/gradle";
          EM_CONFIG = "${configHome}/emscripten/config";
          EM_CACHE = "${cacheHome}/emscripten/cache";
          EM_PORTS = "${dataHome}/emscripten/cache";
          BUNDLE_USER_CONFIG = "${configHome}/bundle";
          BUNDLE_USER_CACHE = "${cacheHome}/bundle";
          BUNDLE_USER_PLUGIN = "${dataHome}/bundle";
          CONDARC = "${configHome}/conda/condarc";
          MC_CONFIG_DIR = "${configHome}/mc";
          BUN_INSTALL = "${dataHome}/bun";
          BUN_CONFIG_DIR = "${configHome}/bun";
          GOPATH = "${dataHome}/go";
          GOMODCACHE = "${cacheHome}/go/mod";
          GOCACHE = "${cacheHome}/go/build";
          VSCODE_PORTABLE = "${dataHome}/vscode";
          STACK_ROOT = "${dataHome}/stack";
          GNUPGHOME = "${dataHome}/gnupg";
          # https://doc.rust-lang.org/cargo/reference/environment-variables.html
          CARGO_HOME = "${dataHome}/cargo";
          RUSTUP_HOME = "${dataHome}/rustup";
        }
        // cfg.extraSessionVariables;

      sessionPath =
        [
          "${h}/.local/bin"
          "${dataHome}/cargo/bin"
          "${configHome}/nimble/bin"
          "${dataHome}/go/bin"
        ]
        ++ cfg.extraSessionPath;

      packages = final;
      inherit (siteLib) stateVersion;
    };

    xdg.configFile = {
      "npm/npmrc".source = ./npmrc;
    };
  };
}
