{ config, pkgs, lib, ... }:
let
  inherit (lib) concatStringsSep optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;
in
{
  programs.neovim.enable = true;
  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/lua";

  programs.neovim.extraConfig = "lua require('init')";
  programs.neovim.vimAlias = true;
  programs.neovim.plugins = with pkgs.vimPlugins; [
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
  # programs.vim.package = pkgs.neovim.override {
  #   vimAlias = true;
  #   configure = {
  #     packages.darwin.start = with pkgs.vimPlugins; [
  #       vim-airline
  #       vim-airline-themes
  #       vim-sensible
  #       vim-surround
  #       vim-fugitive
  #       ReplaceWithRegister
  #       polyglot
  #       fzfWrapper
  #       ale
  #       deoplete-nvim
  #       vim-nix
  #       awesome-vim-colorschemes
  #       nerdtree
  #       vim-markdown
  #       ctrlp
  #     ];
  #     customRC = ''
  #       set encoding=utf-8
  #       set hlsearch
  #       set list
  #       set number
  #       set visualbell
  #       set showcmd
  #       set splitright
  #       set ttyfast
  #       " last line
  #       set showmode
  #       set showcmd
  #       cnoremap %% <C-r>=expand('%:h') . '/'<CR>
  #       nnoremap // :nohlsearch<CR>
  #       let mapleader = ' '
  #       " fzf
  #       nnoremap <Leader>p :FZF<CR>
  #       " vim-surround
  #       vmap s S
  #       " ale
  #       nnoremap <Leader>d :ALEGoToDefinition<CR>
  #       nnoremap <Leader>D :ALEGoToDefinitionInVSplit<CR>
  #       nnoremap <Leader>k :ALESignature<CR>
  #       nnoremap <Leader>K :ALEHover<CR>
  #       nnoremap [a :ALEPreviousWrap<CR>
  #       nnoremap ]a :ALENextWrap<CR>
  #       " deoplete
  #       inoremap <expr><C-g> deoplete#undo_completion()
  #       inoremap <expr><C-l> deoplete#refresh()
  #       inoremap <silent><expr><C-Tab> deoplete#mappings#manual_complete()
  #       inoremap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
  #       let g:deoplete#enable_at_startup = 1
  #       " theme
  #       set t_Co=256
  #       set background=dark
  #       let g:airline_theme='base16'
  #       let g:airline_powerline_fonts = 1
  #       colorscheme nord
  #     '';
  #   };
  # };

  home.sessionVariables = mkIf cfg.defaultEditor {
    EDITOR = "${nvr} --remote-wait-silent";
    VISUAL = "${nvr} --remote-wait-silent";
  };

  programs.fish.functions.nvim-sync-term-buffer-pwd = mkIf cfg.termBufferAutoChangeDir {
    body = ''
      if test -n "$NVIM"
        ${nvr} -c "let g:term_buffer_pwds.$fish_pid = '$PWD' | call Set_term_buffer_pwd() "
      end
    '';
    onVariable = "PWD";
  };

  programs.fish.interactiveShellInit = ''
    " START programs.neovim.extras.termBufferAutoChangeDir config ------------------------------

    " Dictionary used to track the PWD of terminal buffers. Keys should be PIDs and values are
    " is PWD of the shell with that PID. These values are updated from the shell using `nvr`.
    let g:term_buffer_pwds = {}

    " Function to call to update the PWD of the current terminal buffer.
    function Set_term_buffer_pwd() abort
      if &buftype == 'terminal' && exists('g:term_buffer_pwds[b:terminal_job_pid]')
        execute 'lchd ' . g:term_buffer_pwds[b:terminal_job_pid]
      endif
    endfunction

    " Sometimes the PWD the shell in a terminal buffer will change when in another buffer, so
    " when entering a terminal buffer we update try to update it's PWD.
    augroup NvimTermPwd
    au!
    au BufEnter * if &buftype == 'terminal' | call Set_term_buffer_pwd() | endif
    augroup END

    " END programs.neovim.extras.termBufferAutoChangeDir config --------------------------------

    " START programs.neovim.extras.defaultEditor config ----------------------------------------

    let $EDITOR = '${nvr} -cc split -c "set bufhidden=delete" --remote-wait'
    let $VISUAL = $EDITOR

    " END programs.neovim.extras.defaultEditor config ------------------------------------------

    # If shell is running in a Neovim terminal buffer, set the PWD of the buffer to `$PWD`.
    if test -n "$NVIM"; nvim-sync-term-buffer-pwd; end

    # Neovim Remote aliases
    if test -n "$NVIM"
      alias ${edit} "${nvr}"
      alias ${split} "${nvr} -o"
      alias ${vsplit} "${nvr} -O"
      alias ${tabedit} "${nvr} --remote-tab"
      alias ${nvim} "command nvim"
      alias nvim "echo 'This shell is running in a Neovim termainal buffer. Use \'${nvim}\' to a nested instance of Neovim, otherwise use ${edit}, ${split}, ${vsplit}, or ${tabedit} to open files in the this Neovim instance.'"
    else
      alias ${edit} "nvim"
    end
  '';

}
