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
  programs.direnv.stdlib = ''
    # stolen from @i077; store .direnv in cache instead of project dir
    declare -A direnv_layout_dirs
    direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "${config.xdg.cacheHome}"/direnv/layouts/
            echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
    }
    layout_poetry() {
      if [[ ! -f pyproject.toml ]]; then
        log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
        exit 2
      fi
      # create venv if it doesn't exist
      poetry run true
      export VIRTUAL_ENV=$(poetry env info --path)
      export POETRY_ACTIVE=1
      PATH_add "$VIRTUAL_ENV/bin"
    }
  '';

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

  home.sessionVariables.EDITOR = "nvim";

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

  home.packages = with pkgs; [
    # Some basics
    bottom # fancy version of `top` with ASCII graphs
    coreutils
    curl
    du-dust # fancy version of `du`
    # entangled # tangle markdown files
    exa # fancy version of `ls`
    fd # fancy version of `find`
    ffmpeg_5
    htop # fancy version of `top`
    jdk11
    lazygit
    lima
    # lmt # Literate Markdown Text
    mosh # wrapper for `ssh` that better and not dropping connections
    nmap
    nginx
    parallel # runs commands in parallel
    procs # fancy version of `ps`
    ripgrep # better version of `grep`
    tree
    unrar # extract RAR archives
    wget
    xz # extract XZ archives
    youtube-dl


    # Dev stuff
    # (agda.withPackages (p: [ p.standard-library ]))
    cloc # source code line counter
    go_1_19
    google-cloud-sdk
    jq
    yq-go

    # Useful nix related tools
    _1password
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
    m-cli # useful macOS CLI commands
    # prefmanager # tool for working with macOS defaults
  ];
}
