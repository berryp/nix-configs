{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.berryp ];

  options = {
    programs.lmt = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          The Rancher Desktop app
        '';
      };
    };
  };

  config = mkIf config.programs.lmt.enable {
    environment.systemPackages = [ pkgs.lmt ];
    users.groups.adbusers = { };
  };
}
