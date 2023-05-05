{ config, lib, pkgs, ... }:

{
  nix.configureBuildUsers = true;

  nix.settings = {
    substituters = [
      "https://berryp.cachix.org"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "berryp.cachix.org-1:DMNT/b20pztk4CJJL46+HR++LXdypiv3Tr15KQe6F6A="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [ "@admin" "berryp" ];

    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;

    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
  };

  nix = {
    # buildMachines = [
    #   {
    #     hostName = "localhost";
    #     systems = [ "x86_64-linux" "x86_64-darwin" ];
    #     sshUser = "builder";
    #     sshKey = "/etc/nix/builder_ed25519";
    #     maxJobs = 1;
    #     speedFactor = 1;
    #     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    #     mandatoryFeatures = [ ];
    #     # publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtTaG5CSTQ4UFVsWU9kTHN2bkdna2hXRXFvSVdlMzZpRDNrSm5FM3J0anQgYnVpbGRlckBsb2NhbGhvc3QK";
    #   }
    # ];

    # distributedBuilds = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  environment.systemPackages = with pkgs; [
    _1password-gui
    terminal-notifier
    darwin.builder
    #resilio-sync []
  ];

  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';

  programs.zsh.enable = true;

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  # Some apps require residing in /Applications
  # Also makes GUI Applications show up in Spotlight
  system.activationScripts.applications.text = lib.mkForce ''
    echo "Setting up /Applications/Nix Apps" >&2
    appsSrc="${config.system.build.applications}/Applications/"
    baseDir="/Applications/Nix Apps"
    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
    mkdir -p "$baseDir"
    ${pkgs.rsync}/bin/rsync $rsyncArgs "$appsSrc" "$baseDir"
  '';

  system.stateVersion = 4;
}
