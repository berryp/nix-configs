{ config, pkgs, ... }:

let
  inherit (config.home.user-info) nixConfigDirectory;

  aliases = with pkgs; {
    drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    flakeup = "nix flake update ${nixConfigDirectory}";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix search";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${exa}/bin/exa";
    ps = "${procs}/bin/procs";
    tb = "toggle-background";
    k = "kubectl";
    kc = "kubectl";
    kx = "kubectx";
    kn = "kubens";
  };
in
{
  programs.fish.shellAliases = aliases;
  programs.zsh.shellAliases = aliases;
}
