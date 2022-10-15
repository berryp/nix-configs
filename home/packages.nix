{ config, lib, pkgs, ... }:
let
  inherit (config.home.user-info) nixConfigDirectory;
in
{
  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.POETRY_CONFIG_DIR = "${config.xdg.configHome}/pypoetry";

  home.packages = with pkgs; [
    # Some basics
    asciinema
    bottom # fancy version of `top` with ASCII graphs
    coreutils
    curl
    du-dust # fancy version of `du`
    exa # fancy version of `ls`
    fd # fancy version of `find`
    ffmpeg_5
    htop # fancy version of `top`
    k9s
    kubectl
    kubectx
    kubernetes-helm
    kubebuilder
    kubeseal
    kustomize
    lazygit
    lima
    mosh # wrapper for `ssh` that better and not dropping connections
    nmap
    jdk11
    parallel # runs commands in parallel
    python310Full
    python310Packages.pip
    python310Packages.pip
    python310Packages.poetry
    # HACK: MARKED BROKEN
    procs # fancy version of `ps`
    qemu
    ripgrep # better version of `grep`
    thefuck
    unrar # extract RAR archives
    vcluster
    wget
    xz # extract XZ archives
    youtube-dl

    # Dev stuff
    # (agda.withPackages (p: [ p.standard-library ]))
    argocd
    civo
    cloc # source code line counter
    cue
    dagger
    gitsign
    go
    google-cloud-sdk
    jq
    nodejs
    yq-go

    # Useful nix related tools
    alejandra # Formatter
    cachix # adding/managing alternative binary caches hosted by Cachix
    comma # run software from without installing it
    niv # easy dependency management for nix projects
    nix-tree # interactively browse dependency graphs of Nix derivations
    nix-update # swiss-knife for updating nix packages
    nixpkgs-review # review pull-requests on nixpkgs
    rnix-lsp # nix language server
    statix # lints and suggestions for the Nix programming language

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
    prefmanager # tool for working with macOS defaults
  ];
}
