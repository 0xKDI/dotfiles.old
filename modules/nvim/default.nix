{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.neovim;
  nvimDir = builtins.toString ./.;
  lua = arg: if builtins.isPath arg then ''
    luafile ${arg}
  '' else ''
    lua << EOF
    ${arg}
    EOF
  '';
  source = configFile: builtins.readFile configFile;
in
{
  options.modules.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      extraPackages = with pkgs; [
        python38Packages.python-language-server # pyls
        rnix-lsp
        nodePackages.yaml-language-server
        texlab
        terraform-ls
        tree-sitter
      ] ++ optionals config.programs.go.enable [ gopls ];
      withNodeJs = true;
      extraConfig = lua ./init.lua;
      plugins = with pkgs.vimPlugins; [
        {
          plugin = vim-gitgutter;
          config = lua ./vim-gitgutter.lua;
        }
        {
          plugin = vim-fugitive;
          config = lua ./vim-fugitive.lua;
        }
        vim-sneak
        vim-surround
        vim-commentary
        vim-repeat
        vim-obsession # for resurrecting sessions
        vim-devicons
        vim-lion
        auto-pairs
        vim-snippets
        vim-polyglot
        fzfWrapper
        completion-buffers
        {
          plugin = nvim-lspfuzzy;
          config = lua "require('lspfuzzy').setup {}";
        }
        {
          plugin = vim-tmux-navigator;
          config = lua ./vim-tmux-navigator.lua;
        }
        {
          plugin = nvim-treesitter;
          config = lua ./nvim-treesitter.lua;
        }
        {
          plugin = nvim-lspconfig;
          config = lua ./nvim-lspconfig.lua;
        }
        {
          plugin = completion-nvim;
          config = source ./completion-nvim.vim;
        }
        {
          plugin = nvim-colorizer;
          config = lua "require'colorizer'.setup()";
        }
        {
          plugin = fzf-vim;
          config = lua ./fzf-vim.lua;
        }
        {
          plugin = indent-guides-nvim;
          config = lua ./indent-guides-nvim.lua;
        }
        {
          plugin = dracula-vim;
          config = ''
            packadd! dracula-vim
            let g:dracula_italic = 0
            colorscheme dracula
          '';
        }
        {
          plugin = lightline-vim;
          config = source ./lightline-vim.vim;
        }
        {
          plugin = ultisnips;
          config = lua ''
            vim.g.UltiSnipsSnippetDirectories = {"${nvimDir}/snippets"}
            vim.g.UltiSnipsExpandTrigger = "<c-u>"
          '';
        }
      ];
    };


    xdg.configFile = {
      "nvim/init.vim".text = lua "vim.g.polyglot_disabled = {'yaml', 'nix'}";
    };
  };
}
