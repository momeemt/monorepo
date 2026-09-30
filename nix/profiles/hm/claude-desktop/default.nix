{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  path = "Library/Application Support/Claude/claude_desktop_config.json";
  mcpObsidianWrapper = let
    host = "127.0.0.1";
    port = "27124";
    apiKeyFile = config.sops.secrets."obsidian/api_key".path;
  in
    pkgs.writeShellScript "mcp-obsidian-wrapper" ''
      set -eu
      export OBSIDIAN_API_KEY="$(cat ${apiKeyFile})"
      export OBSIDIAN_HOST="${host}"
      export OBSIDIAN_PORT="${port}"
      exec ${lib.getExe' pkgs.uv "uvx"} mcp-obsidian
    '';
  mcpBlueskyWrapper = let
    identifier = "momee.mt";
    passwordFile = config.sops.secrets."bluesky/momee_mt_password".path;
  in
    pkgs.writeShellScript "mcp-bluesky-wrapper" ''
      set -eu
      export BLUESKY_IDENTIFIER="${identifier}"
      export BLUESKY_PASSWORD="$(cat ${passwordFile})"
      exec ${pkgs.bluesky-mcp}/bin/bluesky-mcp
    '';
in {
  home.file."${path}" = {
    force = true;
    source = inputs.mcp-servers-nix.lib.mkConfig pkgs {
      programs = {
        context7.enable = true;
        time.enable = true;
        memory.enable = true;
        serena.enable = true;
        github = {
          enable = true;
          envFile = config.sops.secrets."github/claude_desktop_token".path;
        };
        codex.enable = true;
      };
      settings.servers = {
        mcp-obsidian = {
          command = "${mcpObsidianWrapper}";
          args = [];
        };
        activitywatch = {
          command = "${pkgs.activitywatch-mcp-server}/bin/activitywatch-mcp-server";
          args = [];
        };
        bluesky = {
          command = "${mcpBlueskyWrapper}";
          args = [];
        };
      };
      settings.preferences = {
        coworkScheduledTasksEnabled = false;
        ccdScheduledTasksEnabled = false;
        coworkWebSearchEnabled = true;
        floatingAtollActive = true;
      };
    };
  };
}
