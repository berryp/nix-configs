_: super:
{
  lmt = super.callPackage ./lmt { };

  obsidian-export = super.callPackage ./obsidian-export { };

  obsidianhtml = super.callPackage ./obsidianhtml { };

  rancher-desktop = super.callPackage ./rancher-desktop { };

  raycast = super.callPackage ./raycast { };

  resilio-sync = super.callPackage ./resilio-sync { };

  warp-terminal = super.callPackage ./warp-terminal { };
}
