HOSTNANE=$(shell hostname | tr -d '.local')
KERNEL=$(shell uname -a | tr '[:upper:]' '[:lower:]')

.PHONY: bootstrap-Berrys-MBP-SW
bootstrap-Berrys-MBP-SW:
	sudo rm -f ~/.nix-defexpr/channels
	printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
	/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	nix build --experimental-features 'nix-command flakes' '.#$(KERNEL)Configurations.$(HOSTNANE).system'
	./result/sw/bin/darwin-rebuild switch --flake .

.PHONY: darwin-rebuild
darwin-rebuild:
	darwin-rebuild switch --flake .

.PHONY: nix-rebuild
nix-rebuild:
	darwin-rebuild switch --flake .
