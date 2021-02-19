{ config, pkgs, ... }:

{
  xdg.configFile."nvim/init.vim".text = "let g:polyglot_disabled = ['yaml']";


  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraPackages = with pkgs; [
      python38Packages.python-language-server # pyls
      rnix-lsp
      nodePackages.yaml-language-server
      texlab
      terraform-ls
      gopls
    ];
    extraConfig = builtins.readFile "${config.dots.confDir}/nvim/init.vim";
    plugins = with pkgs.vimPlugins; [
      vim-gitgutter
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
        config = ''
          lua require('lspfuzzy').setup {}
        '';
      }
      {
        plugin = vim-tmux-navigator;
        config = ''
          let g:tmux_navigator_no_mappings = 1

          nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
          nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
          nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
          nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
          nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
        '';
      }
      {
        plugin = nvim-lspconfig;
        config = "luafile ${config.dots.confDir}/nvim/lspconfig.lua";
      }
      {
        plugin = completion-nvim;
        config = builtins.readFile "${config.dots.confDir}/nvim/completion.vim";
      }
      {
        plugin = fzf-checkout;
        config = "nnoremap <silent> <leader>gb :GBranches<CR>";
      }
      {
        plugin = nvim-colorizer;
        config = "lua require'colorizer'.setup()";
      }
      {
        plugin = fzf-vim;
        config = builtins.readFile "${config.dots.confDir}/nvim/fzf-vim.vim";
      }
      {
        plugin = vim-fugitive;
        config = ''
          nnoremap <leader>gg :G<CR>
          nnoremap <leader>gl :Gllog<CR>
        '';
      }
      {
        plugin = indentLine;
        config = ''
          let g:indentLine_enabled = 0
          let indentLine_char = '│'
        '';
      }
      {
        plugin = dracula-vim;
        config = ''
          packadd! dracula-vim
          colorscheme dracula
        '';
      }
      {
        plugin = lightline-vim;
        config = builtins.readFile "${config.dots.confDir}/nvim/lightline-vim.vim";
      }
      {
        plugin = ultisnips;
        config = ''
          let g:UltiSnipsSnippetDirectories=["${config.dots.confDir}/nvim/UltiSnips"]
          let g:UltiSnipsExpandTrigger="<c-u>"
        '';
      }
    ];
  };
}
