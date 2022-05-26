{ config, lib, pkgs, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;
in

{
  programs.zsh.enable = false;

  home.packages = [ ];

  # # Aliases
  # programs.zsh.shellAliases = with pkgs; {
  #   # Nix related
  #   drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
  #   drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
  #   flakeup = "nix flake update ${nixConfigDirectory}";
  #   nb = "nix build";
  #   nd = "nix develop";
  #   nf = "nix flake";
  #   nr = "nix run";
  #   ns = "nix search";

  #   # Other
  #   ".." = "cd ..";
  #   ":q" = "exit";
  #   cat = "${bat}/bin/bat";
  #   du = "${du-dust}/bin/dust";
  #   g = "${gitAndTools.git}/bin/git";
  #   la = "ll -a";
  #   ll = "ls -l --time-style long-iso --icons";
  #   ls = "${exa}/bin/exa";
  #   ps = "${procs}/bin/procs";
  #   tb = "toggle-background";
  #   k = "kubectl";
  #   kc = "kubectl";
  #   kx = "kubectx";
  #   kn = "kubens";
  # };

  programs.zsh.history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  programs.zsh.prezto = {
    enable = true;
    tmux.itermIntegration = true;
    prompt.theme = "sorin";
  };
}
