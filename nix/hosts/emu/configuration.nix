{
  config,
  pkgs,
  siteLib,
  ...
}: {
  imports = [
    ../../profiles/sops
    ../../profiles/comin
    ../../profiles/hosts/services/displayManager
    ../../profiles/hosts/services/openssh
    ../../profiles/hosts/services/resolved
    ../../profiles/hosts/services/tailscale
    ../../profiles/hosts/services/xrdp
    ../../profiles/hosts/services/xserver
    ../../profiles/hosts
    ./k8s
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "emu";
    useNetworkd = true;

    interfaces = {
      enp3s0.useDHCP = false;

      br0.ipv4.addresses = [
        {
          address = siteLib.ip.emu;
          prefixLength = 24;
        }
      ];
    };

    bridges.br0.interfaces = ["enp3s0"];

    defaultGateway = {
      address = siteLib.ip.defaultGateway;
      interface = "br0";
    };

    firewall = {
      allowedTCPPorts = [
        53
        80
        443
      ];
      allowedUDPPorts = [
        53
        443
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    sway.enable = true;
    zsh.enable = true;
  };

  users.users.momeemt = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.momeemt-password.path;
    openssh.authorizedKeys.keys = siteLib.publicKeys;
  };

  users.users.caddy.extraGroups = ["mastodon"];

  services = {
    caddy = {
      enable = true;
      email = "me@momee.mt";

      virtualHosts."photo.kitsutsuki.momee.mt".extraConfig = ''
        redir / /photo/ 308

        reverse_proxy https://192.168.1.33:5001 {
          header_up Host {host}

          transport http {
            tls_insecure_skip_verify
          }
        }
      '';

      virtualHosts."mastodon.momee.mt".extraConfig = ''
        handle_path /system/* {
          root * /var/lib/mastodon/public-system
          file_server
        }

        handle /api/v1/streaming/* {
          reverse_proxy unix//run/mastodon-streaming/streaming-1.socket
        }

        route * {
          file_server * {
            root ${pkgs.mastodon}/public
            pass_thru
          }

          reverse_proxy * unix//run/mastodon-web/web.socket
        }

        handle_errors {
          root * ${pkgs.mastodon}/public
          rewrite * /500.html
          file_server
        }

        encode gzip

        header /* {
          Strict-Transport-Security "max-age=31536000;"
        }

        header /emoji/* Cache-Control "public, max-age=31536000, immutable"
        header /packs/* Cache-Control "public, max-age=31536000, immutable"
        header /system/accounts/avatars/* Cache-Control "public, max-age=31536000, immutable"
        header /system/media_attachments/files/* Cache-Control "public, max-age=31536000, immutable"
      '';

      virtualHosts."attic.momee.mt".extraConfig = ''
        reverse_proxy 127.0.0.1:8080
      '';
    };

    dnsmasq = {
      enable = true;
      settings = {
        listen-address = ["127.0.0.1" "192.168.1.37"];
        bind-interfaces = true;

        no-resolv = true;
        local-ttl = 60;
        cache-size = 10000;

        address = [
          "/photo.kitsutsuki.momee.mt/192.168.1.37"
          "/mastodon.momee.mt/192.168.1.37"
          "/attic.momee.mt/192.168.1.37"
        ];

        server = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };

    cloudflared = {
      enable = true;
      tunnels = {
        "053a4ebe-82c3-485a-bc8b-f0768cbe1d11" = {
          credentialsFile = "${config.sops.secrets."cloudflared/emu.json".path}";
          ingress = {
            "emu.momee.mt" = {
              service = "ssh://localhost:22";
            };
            "s3.momee.mt" = {
              service = "http://localhost:9000";
            };
          };
          default = "http_status:404";
        };
        "b2b83e61-577c-45e7-b1c0-0961503e8d8d" = {
          credentialsFile = "${config.sops.secrets."cloudflared/emu-desktop.json".path}";
          ingress = {
            "emu-desktop.momee.mt" = {
              service = "rdp://localhost:3389";
            };
          };
          default = "http_status:404";
        };
      };
    };

    mastodon = {
      enable = true;
      localDomain = "mastodon.momee.mt";
      configureNginx = false;
      streamingProcesses = 2;
      webProcesses = 2;
      webThreads = 5;

      smtp = {
        createLocally = false;
        host = "smtp.resend.com";
        port = 587;
        authenticate = true;
        user = "resend";
        passwordFile = "${config.sops.secrets."resend/mastodon.momee.mt".path}";
        fromAddress = "Mastodon <notifications@mastodon.momee.mt>";
      };

      extraConfig = {
        SMTP_ENABLE_STARTTLS_AUTO = "true";
        SMTP_AUTH_METHOD = "plain";
      };
    };

    udev.packages = [pkgs.usb-blaster-udev-rules];

    atticd = {
      enable = true;
      environmentFile = config.sops.secrets."atticd/emu/env".path;

      settings = {
        listen = "127.0.0.1:8080";
        api-endpoint = "https://attic.momee.mt/";
        jwt = {};

        chunking = {
          nar-size-threshold = 64 * 1024;
          min-size = 16 * 1024;
          avg-size = 64 * 1024;
          max-size = 256 * 1024;
        };
      };
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/100390
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
      };
    };

    libvirt = {
      enable = true;
      verbose = true;
      connections."qemu:///system".pools = null;
    };
  };
}
