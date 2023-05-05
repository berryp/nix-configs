_: pkgs:
{
  lmt = pkgs.callPackage ./lmt { };
  obsidian-export = pkgs.callPackage ./obsidian-export { };
  # obsidianhtml = pkgs.callPackage ./obsidianhtml { };
  rancher-desktop = pkgs.callPackage ./rancher-desktop { };
  raycast = pkgs.callPackage ./raycast { };
  resilio-sync = pkgs.callPackage ./resilio-sync { };
}
