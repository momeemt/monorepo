{
  tmuxPlugins,
  fetchFromGitHub,
  python3,
  python3Packages,
  tmux,
  ps,
  lib,
}: let
  pythonEnv = python3.withPackages (
    ps:
      with ps; [
        python3Packages.pip
        python3Packages.libtmux
      ]
  );
in
  tmuxPlugins.mkTmuxPlugin rec {
    pluginName = "tmux-window-name";
    version = "fe4d65a14f80fb4b681b7e2dcf361ada88733203";
    rtpFilePath = (builtins.replaceStrings ["-"] ["_"] pluginName) + ".tmux";
    src = fetchFromGitHub {
      owner = "ofirgall";
      repo = "tmux-window-name";
      rev = "fe4d65a14f80fb4b681b7e2dcf361ada88733203";
      sha256 = "sha256-3LyS52Bi49IePkA2JbjDxqhooV5V0vT+4Wu+ykWrp0w=";
    };
    nativeBuildInputs = [pythonEnv tmux ps];
    postInstall = ''
      sed -i -e 's|python3 |${pythonEnv}/bin/python3 |g' $target/tmux_window_name.tmux
      sed -i -e 's|'ps'|'${ps}/bin/ps'|g' $target/scripts/rename_session_windows.py
      sed -i -e 's|#!/usr/bin/env python3|#!${pythonEnv}/bin/python3|g' $target/scripts/rename_session_windows.py
    '';
    meta = {
      homepage = "https://github.com/ofirgall/tmux-window-name";
      description = "A plugin to name your tmux windows smartly.";
      license = lib.licenses.mit;
    };
  }
