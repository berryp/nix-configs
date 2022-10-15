{ config, pkgs, lib, ... }:
let
  inherit (lib) optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;

  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });

  nonVSCodePluginWithConfig = plugin: {
    inherit plugin;
    optional = true;
    config = ''
      if !exists('g:vscode')
        lua require('malo.' .. string.gsub('${plugin.pname}', '%.', '-'))
      endif
    '';
  };

  nonVSCodePlugin = plugin: {
    inherit plugin;
    optional = true;
    config = ''
      if !exists('g:vscode') | packadd ${plugin.pname} | endif
    '';
  };
in
{
  programs.neovim.enable = true;

  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/lua";
  xdg.configFile."nvim/colors".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim/colors";
  programs.neovim.extraConfig = "lua require('init')";

  programs.neovim.extraLuaPackages = [ pkgs.lua51Packages.penlight ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    lush-nvim
    tabular
    vim-commentary
    vim-eunuch
    vim-surround
  ] ++ map (p: { plugin = p; optional = true; }) [
    which-key-nvim
    zoomwintab-vim
  ] ++ map nonVSCodePlugin [
    agda-vim
    direnv-vim
    goyo-vim
    vim-fugitive
  ] ++ map nonVSCodePluginWithConfig [
    (pluginWithDeps coq_nvim [ coq-artifacts coq-thirdparty ])
    editorconfig-vim
    (pluginWithDeps galaxyline-nvim [ nvim-web-devicons ])
    gitsigns-nvim
    indent-blankline-nvim
    lsp_lines-nvim
    lspsaga-nvim
    (pluginWithDeps bufferline-nvim [ nvim-web-devicons ])
    null-ls-nvim
    nvim-lastplace
    nvim-lspconfig
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    (pluginWithDeps telescope-nvim [
      nvim-web-devicons
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      telescope-zoxide
    ])
    toggleterm-nvim
    vim-pencil
    vim-polyglot
  ];

  programs.neovim.extraPackages = with pkgs; [
    # Bash
    shellcheck

    # Nix
    deadnix
    statix
    rnix-lsp

    # Python
    black
    pyright
  ];
}
