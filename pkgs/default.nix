{ pkgs, ... }:

{
  packages = {
    lmt = pkgs.callPackage ./lmt { inherit pkgs; };
    rancher-desktop = pkgs.callPackage ./rancher-desktop { inherit pkgs; };
    resilio-sync = pkgs.callPackage ./resilio-sync { inherit pkgs; };
  };
}

