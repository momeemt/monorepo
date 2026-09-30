{
  config,
  lib,
  options,
  ...
}: {
  sops = {
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];
    defaultSopsFile = ../../../secrets/secrets.enc.yml;
    secrets =
      {
        momeemt-password = {
          neededForUsers = true;
        };
        k8s-bootstrap-token = {};
        "atticd/emu/env" = {
          mode = "0400";
        };

        "cloudflared/emu.json" = {
          format = "json";
          sopsFile = ../../../secrets/cloudflared/emu.enc.json;
          key = "";
          mode = "0400";
        };

        "cloudflared/emu-desktop.json" = {
          format = "json";
          sopsFile = ../../../secrets/cloudflared/emu-desktop.enc.json;
          key = "";
          mode = "0400";
        };

        "k8s/ca.key" = {
          format = "binary";
          sopsFile = ../../../secrets/k8s/ca.enc.key;
          mode = "0400";
        };
      }
      // lib.optionalAttrs (options ? services && options.services ? mastodon) {
        "resend/mastodon.momee.mt" = {
          owner = config.services.mastodon.user;
          group = config.services.mastodon.group;
          mode = "0400";
        };
      };
  };
}
