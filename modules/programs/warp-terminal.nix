{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.berryp ];

  options = {
    programs.warp-terminal = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Warp Terminal
        '';
      };
    };
  };

  config = mkIf config.programs.warp-terminal.enable {
    environment.systemPackages = [ pkgs.warp-terminal ];
    users.groups.adbusers = { };
  };
}
