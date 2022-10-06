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

    # youtube-dl
    ytmp3 = "youtube-dl -x --audio-format mp3";
    ytpm4 = "youtube-dl --format 'bestvideo+bestaudio[ext=m4a]/bestvideo+bestaudio/best' --merge-output-format mp4";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${exa}/bin/exa";
    # ps = "${procs}/bin/procs";
    tb = "toggle-background";
    k = "kubectl";
    kc = "kubectl";
    kx = "kubectx";
    kn = "kubens";
    rdlima = "LIMA_HOME=\"$HOME/Library/Application Support/rancher-desktop/lima\" \"/Applications/Rancher Desktop.app/Contents/Resources/resources/darwin/lima/bin/limactl\" shell 0";
  };
in
{
  programs.fish.shellAliases = aliases;
  programs.zsh.shellAliases = aliases;
}
