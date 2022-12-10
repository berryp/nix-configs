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

  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    recursive
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];


  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  security.pam.enableSudoTouchIdAuth = true;
}
