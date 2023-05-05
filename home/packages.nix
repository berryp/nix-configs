{ config, lib, pkgs, ... }:

{
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  programs.direnv.enable = true;
  programs.direnv.stdlib = ''
    : ''${XDG_CACHE_HOME:=$HOME/.cache}
    declare -A direnv_layout_dirs
    direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
    }
  '';
  programs.direnv.nix-direnv.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # SSH
  # https://nix-community.github.io/home-manager/options.html#opt-programs.ssh.enable
  # Some options also set in `../darwin/homebrew.nix`.
  programs.ssh.enable = true;
  programs.ssh.controlPath = "~/.ssh/%C"; # ensures the path is unique but also fixed lengt

  programs.exa.enable = true;
  programs.exa.enableAliases = true;

  programs.fzf.enable = true;
  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.tmux.enableShellIntegration = true;

  programs.zoxide.enable = true;

  programs.jq.enable = true;

  programs.pandoc.enable = true;
  programs.pandoc.defaults = {
    metadata = { author = "Berry Phillips"; };
  };

  programs.nushell.enable = true;

  programs.tmux.enable = true;
  programs.tmux.baseIndex = 1;
  programs.tmux.clock24 = true;
  programs.tmux.keyMode = "vi";
  programs.tmux.shell = "${pkgs.fish}/bin/fish";
  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    cpu
    yank
    tmux-thumbs
    tilish
    {
      plugin = resurrect;
      extraConfig = "set -g @resurrect-strategy-nvim 'session'";
    }
    {
      plugin = continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '60' # minutes
      '';
    }
  ];

  home.packages = lib.attrValues ({
    # Some basics
    inherit (pkgs)
      bottom# fancy version of `top` with ASCII graphs
      coreutils
      curl
      du-dust# fancy version of `du`
      exa# fancy version of `ls`
      fd# fancy version of `find`
      htop# fancy version of `top`
      mosh# wrapper for `ssh` that better and not dropping connections
      obsidian-export
      openssh
      parallel# runs commands in parallel
      ripgrep# better version of `grep`
      thefuck
      upterm# secure terminal sharing
      terminal-notifier
      tree
      wget
      xz# extract XZ archives
      yq-go
      ;


    inherit (pkgs.python310Packages)
      mkdocs
      pip
      ;

    # Dev stuff
    inherit (pkgs)
      cloc# source code line counter
      jq
      git
      git-secret
      go_1_19
      gnupg
      gpg-tui
      python310
      buf
      devbox
      hugo
      ghq
      gh
      protobuf
      plantuml
      terraform
      ;

    # Useful nix related tools
    inherit (pkgs)
      alejandra
      cachix# adding/managing alternative binary caches hosted by Cachix
      comma# run software from without installing it
      deadnix
      niv# easy dependency management for nix projects
      nix-output-monitor# get additional information while building packages
      nix-tree# interactively browse dependency graphs of Nix derivations
      nix-update# swiss-knife for updating nix packages
      nixpkgs-review# review pull-requests on nixpkgs
      rnix-lsp
      statix# lints and suggestions for the Nix programming language
      nurl
      helix
      ;

  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    inherit (pkgs)
      # cocoapods
      m-cli# useful macOS CLI commands
      # prefmanager# tool for working with macOS defaults
      # discord
      # zoom-us
      # rancher-desktop
      # warp-terminal
      # (python310.withPackages (ps: with ps; [ obsidianhtml ]))
      ;
  });
}

