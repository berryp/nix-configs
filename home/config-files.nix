{ config, lib, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
in
{
  xdg.configFile."direnv/config.toml".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/direnv/config.toml";
}
