{ pkgs, config, lib, outputs, ... }:

{
  users.users.berryp = {
    shell = pkgs.fish;
  };
}
