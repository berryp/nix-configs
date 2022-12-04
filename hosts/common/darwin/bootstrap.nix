{ config, lib, pkgs, ... }:

{
  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.etc = {
    "sudoers.d/10-nix-commands".text =
      let
        commands = [
          "/run/current-system/sw/bin/darwin-rebuild"
          "/run/current-system/sw/bin/nix*"
          "/run/current-system/sw/bin/ln"
          "/nix/store/*/activate"
          "/bin/launchctl"
        ];
        commandsString = builtins.concatStringsSep ", " commands;
      in
      ''
        %admin ALL=(ALL:ALL) NOPASSWD: ${commandsString}
      '';
  };

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
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
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
}
