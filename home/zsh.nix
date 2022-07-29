{ config, lib, pkgs, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;
in

{
  programs.zsh.enable = false;

  home.packages = [ ];

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
