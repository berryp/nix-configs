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

  programs.vim.package = pkgs.neovim.override {
    vimAlias = true;
    configure = {
      packages.darwin.start = with pkgs.vimPlugins; [
        vim-airline
        vim-airline-themes
        vim-sensible
        vim-surround
        vim-fugitive
        ReplaceWithRegister
        polyglot
        fzfWrapper
        ale
        deoplete-nvim
        vim-nix
        awesome-vim-colorschemes
        nerdtree
        vim-markdown
        ctrlp
      ];
      customRC = ''
        set encoding=utf-8
        set hlsearch
        set list
        set number
        set visualbell
        set showcmd
        set splitright
        set ttyfast
        " last line
        set showmode
        set showcmd
        cnoremap %% <C-r>=expand('%:h') . '/'<CR>
        nnoremap // :nohlsearch<CR>
        let mapleader = ' '
        " fzf
        nnoremap <Leader>p :FZF<CR>
        " vim-surround
        vmap s S
        " ale
        nnoremap <Leader>d :ALEGoToDefinition<CR>
        nnoremap <Leader>D :ALEGoToDefinitionInVSplit<CR>
        nnoremap <Leader>k :ALESignature<CR>
        nnoremap <Leader>K :ALEHover<CR>
        nnoremap [a :ALEPreviousWrap<CR>
        nnoremap ]a :ALENextWrap<CR>
        " deoplete
        inoremap <expr><C-g> deoplete#undo_completion()
        inoremap <expr><C-l> deoplete#refresh()
        inoremap <silent><expr><C-Tab> deoplete#mappings#manual_complete()
        inoremap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
        let g:deoplete#enable_at_startup = 1
        " theme
        set t_Co=256
        set background=dark
        let g:airline_theme='base16'
        let g:airline_powerline_fonts = 1
        colorscheme nord
      '';
    };
  };

  programs.jq.enable = true;

  programs.pandoc.enable = true;
  programs.pandoc.defaults = {
    metadata = { author = "Berry Phillips"; };
  };

  programs.nushell.enable = true;

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
      gh
      protobuf
      plantuml
      terraform
      ;
    inherit (pkgs.haskellPackages)
      cabal-install
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
      ;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    inherit (pkgs)
      # cocoapods
      m-cli# useful macOS CLI commands
      # prefmanager# tool for working with macOS defaults
      discord
      iterm2
      obsidian
      pinentry_mac
      rectangle
      raycast
      utm
      zoom-us
      # resilio-sync
      # rancher-desktop
      # warp-terminal
      # (python310.withPackages (ps: with ps; [ obsidianhtml ]))
      ;
  });
}
