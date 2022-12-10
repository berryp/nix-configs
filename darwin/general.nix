{ pkgs, lib, config, ... }:

{
  # Make GUI Applications show up in Spotlight
  # system.activationScripts.applications.text = lib.mkForce ''
  #   echo "Setting up /Applications/Nix Apps" >&2
  #   appsSrc="${config.system.build.applications}/Applications/"
  #   baseDir="/Applications/Nix Apps"
  #   rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
  #   mkdir -p "$baseDir"
  #   ${pkgs.rsync}/bin/rsync $rsyncArgs "$appsSrc" "$baseDir"
  # '';

  # Networking
  networking.dns = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  nixpkgs.config.allowUnfree = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    age
    git
    git-secret
    ripgrep
    terminal-notifier
    openssh
    git-secret
    gnupg
    gpg-tui
  ];

  # programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];


  # services.synergy = {
  #   server = { enable = true; address = "192.168.75.189:24800"; };
  # };

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
