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
      package = pkgs.neovim-unwrapped;
      extraPackages = with pkgs; [
        python-language-server # pyls
        rnix-lsp
        nodePackages.yaml-language-server
        terraform-ls
        tree-sitter
      ] ++ optionals config.programs.go.enable [ unstable.gopls ];
      withNodeJs = true;
      extraConfig = lua ./init.lua;
      plugins = with pkgs.vimPlugins; [
        {
          plugin = nvim-web-devicons;
          config = lua ./_before.lua;
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
          plugin = indent-guides-nvim;
          config = lua ./indent-guides-nvim.lua;
        }
        {
          plugin = vim-fugitive;
          config = lua ./vim-fugitive.lua;
        }
        {
          plugin = vim-gitgutter;
          config = lua ./vim-gitgutter.lua;
        }
        vim-sneak
        vim-surround
        vim-commentary
        vim-repeat
        vim-obsession # for resurrecting sessions
        vim-lion
        {
          plugin = nvim-autopairs;
          config = lua ''
          local npairs = require('nvim-autopairs')
          npairs.setup({ map_cr = false })
          '';
        }
        {
          plugin = vim-polyglot;
          optional = true;
          config = ''
            let g:polyglot_disabled = ['yaml']
            packadd! vim-polyglot
          '';
        }
        {
          plugin = fzf-vim;
          config = lua ./fzf-vim.lua;
        }
        fzfWrapper
        {
          plugin = nvim-lspfuzzy;
          config = lua "require('lspfuzzy').setup{}";
        }
        {
          plugin = vim-tmux-navigator;
          config = lua ./vim-tmux-navigator.lua;
        }
        {
          plugin = nvim-treesitter;
          config = lua ./nvim-treesitter.lua;
        }
        coq_nvim
        {
          plugin = nvim-lspconfig;
          config = lua ./nvim-lspconfig.lua;
        }
        {
          plugin = nvim-colorizer-lua;
          config = lua "require'colorizer'.setup()";
        }
        {
          plugin = lualine-nvim;
          config = lua ./lualine-nvim.lua;
        }
        {
          plugin = which-key-nvim;
          config = lua "require('which-key').setup()";
        }
        {
          plugin = comment-nvim;
          config = lua "require('Comment').setup()";
        }
      ];
    };
  };
}
