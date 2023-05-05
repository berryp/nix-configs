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

  environment.systemPackages = with pkgs; [
    iterm2
    obsidian
    rectangle
    raycast
    utm
    tailscale
    rancher-desktop
    termshark
    # devenv
  ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771172;
        HIDKeyboardModifierMappingDst = 30064771125;
      }
    ];
  };


  security.pam.enableSudoTouchIdAuth = true;
}
