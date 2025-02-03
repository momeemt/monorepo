#!/usr/bin/env zsh
set -eo pipefail

rm -rf poac-out/debug/rin.d poac-out/debug/rin
mini_compile_commands_server.py &
pid=$!
sleep 0.2
cd poac-out/debug
make
kill -s SIGINT "$pid"

