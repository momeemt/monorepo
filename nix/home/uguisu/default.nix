{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../../profiles/nixvim
    ../../profiles/hm/accounts/calendar
    ../../profiles/hm/accounts/contact
    ../../profiles/hm/accounts/email
    ../../profiles/hm/claude-desktop
    ../../profiles/hm/editorconfig
    ../../profiles/hm/homebrew
    ../../profiles/hm/programs
    ../../profiles/hm/programs/ssh
    ../../profiles/hm/programs/tmux
    ../../profiles/hm/services
    ../../profiles/hm/sops
    ../../profiles/hm/wakatime
  ];

  # Avoid in-place rsync updates of running app bundles.
  targets.darwin = {
    copyApps.enable = lib.mkForce false;
    linkApps.enable = lib.mkForce true;
  };

  home.activation.prepareHomeManagerAppsLink = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    target="$HOME/Applications/Home Manager Apps"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      backup="$target.before-linkApps"
      n=0

      while [ -e "$backup" ]; do
        n=$((n + 1))
        backup="$target.before-linkApps-$n"
      done

      run mv "$target" "$backup"
    fi
  '';

  site = {
    home = {
      username = "momeemt";
      groups.darwinCasks = true;
      extraDarwinCasks = with pkgs.brewCasks; [
        anki
      ];
      extraSessionPath = [
        "${config.home.homeDirectory}/Library/Application Support/JetBrains/Toolbox/scripts"
      ];
    };

    programs = {
      nimble = {
        enable = true;
        nimbleDir = "${config.xdg.configHome}/nimble/";
      };
      wget.enable = true;
      # karabiner-elements = {
      #   enable = true;
      #   settings.profiles = [
      #     {
      #       name = "Default";
      #       selected = true;
      #       simple_modifications = [
      #         {
      #           from = {key_code = "q";};
      #           to = [{key_code = "p";}];
      #         }
      #       ];
      #     }
      #   ];
      # };
    };

    languages = {
      python = {
        enable = true;
      };
    };
  };

  programs = {
    git = {
      signing = {
        key = "ACB54F0CBC6AA7C6";
        signByDefault = true;
      };
    };
    aerc = {
      enable = true;
      extraConfig = {
        general = {
          # Allow accounts.conf (0444) from nix-store
          "unsafe-accounts-conf" = true;
        };
      };
    };
    lieer.enable = true;
    notmuch.enable = true;
    khal.enable = true;
    vdirsyncer.enable = true;
    khard.enable = true;
  };

  services.vdirsyncer.enable = true;
}
