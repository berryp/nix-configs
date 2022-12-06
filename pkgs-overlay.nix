_: super:
{
  lmt = super.callPackage ./pkgs/lmt { };
  obsidian-export = super.callPackage ./pkgs/obsidian-export { };
  # obsidianhtml = super.callPackage ./pkgs/obsidianhtml { };
  rancher-desktop = super.callPackage ./pkgs/rancher-desktop { };
  resilio-sync = super.callPackage ./pkgs/resilio-sync { };
  warp-terminal = super.callPackage ./pkgs/warp-terminal { };
}
