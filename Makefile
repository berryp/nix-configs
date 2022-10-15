.PHONY: update
update:
	nix flake update

.PHONY: bootstrap-macos
bootstrap-macos: update
	echo -e "run\tprivate/var/run" | sudo tee -a /etc/synthetic.conf >/dev/null
	/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t &>/dev/null || true
	nix build .#darwinConfigurations.bootstrap-x86.system
	./result/sw/bin/darwin-rebuild switch --flake .#bootstrap-x86
	/run/current-system/sw/bin/fish -c 'darwin-rebuild switch --flake .'

.PHONY: bootstrap-linux
bootstrap-linux: update
	nix build .#cloudVM.activationPackage; ./result/activate

upgrade-macos:
	sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
