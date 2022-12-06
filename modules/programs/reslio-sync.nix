{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.berryp ];

  options = {
    programs.resilio-sync = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Resilio Sync
        '';
      };
    };
  };

  config = mkIf config.programs.resilio-sync.enable {
    environment.systemPackages = [ pkgs.resilio-sync ];
    users.groups.adbusers = { };
  };
}
