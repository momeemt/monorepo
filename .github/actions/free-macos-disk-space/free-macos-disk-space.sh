#!/usr/bin/env bash
set -euxo pipefail

df -h
sudo du -sh /Applications/Xcode*.app /Library/Developer/CoreSimulator /Users/runner/hostedtoolcache /usr/local/lib/android 2>/dev/null || true
if [[ -d /Library/Developer/CommandLineTools ]]; then
  sudo xcode-select -s /Library/Developer/CommandLineTools || true
fi
sudo rm -rf /Applications/Xcode*.app
sudo rm -rf /Library/Developer/CoreSimulator/Profiles/Runtimes/*.simruntime
sudo rm -rf /Library/Developer/CoreSimulator
sudo rm -rf "$HOME/Library/Developer/CoreSimulator"
sudo rm -rf "$HOME/hostedtoolcache"
sudo rm -rf /Users/runner/hostedtoolcache
sudo rm -rf /usr/local/lib/android
brew cleanup --prune=all || true
df -h
