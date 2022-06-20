#!/usr/bin/env bash

set -e -o pipefail

if [[ ! -d "/run" ]]; then
  echo -e "run\tprivate/var/run" | sudo tee -a /etc/synthetic.conf >/dev/null
  /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t &>/dev/null || true
fi

if [[ ! -d "result" ]]; then
  nix build --experimental-features 'nix-command flakes' .#darwinConfigurations.bootstrap-x86.system
fi

# https://logs.nix.samueldr.com/nix-darwin/2020-02-03
nix-collect-garbage --max-freed 10m

./result/sw/bin/darwin-rebuild switch --flake .#bootstrap-x86
/run/current-system/sw/bin/fish -c 'darwin-rebuild switch --flake .'

#nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' --flake ."
