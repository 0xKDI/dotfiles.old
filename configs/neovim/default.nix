{ config, pkgs, ... }:

let
  nvimDir = builtins.toString ./.;
  vimPlugins = pkgs.vimPlugins;
in
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
    extraConfig = builtins.readFile "${nvimDir}/init.vim";
    plugins = with vimPlugins; [
      {
        plugin = vim-gitgutter;
        config = ''
          " Update sign column every 1/4 second
          set updatetime=250
          nmap <Leader>gn <Plug>(GitGutterNextHunk)
          nmap <Leader>gp <Plug>(GitGutterPrevHunk)

          nmap <Leader>ga <Plug>(GitGutterStageHunk)
          nmap <Leader>gu <Plug>(GitGutterUndoHunk)
        '';
      }
      {
        plugin = vim-fugitive;
        config = ''
          nnoremap <leader>gg :tab G<CR>
          nnoremap <leader>gl :tab Gllog<CR>
          nnoremap <leader>grb :tab G rebase -i<CR>
        '';
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
        plugin = nvim-treesitter;
        config = "luafile ${nvimDir}/tree-sitter.lua";
      }
      {
        plugin = nvim-lspconfig;
        config = "luafile ${nvimDir}/lspconfig.lua";
      }
      {
        plugin = completion-nvim;
        config = builtins.readFile "${nvimDir}/completion.vim";
      }
      {
        plugin = nvim-colorizer;
        config = "lua require'colorizer'.setup()";
      }
      {
        plugin = fzf-vim;
        config = builtins.readFile "${nvimDir}/fzf-vim.vim";
      }
      {
        plugin = indent-guides-nvim;
        config = "luafile ${nvimDir}/indent-guides.lua";
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
        config = builtins.readFile "${nvimDir}/lightline-vim.vim";
      }
      {
        plugin = ultisnips;
        config = ''
          let g:UltiSnipsSnippetDirectories=["${nvimDir}/snippets"]
          let g:UltiSnipsExpandTrigger="<c-u>"
        '';
      }
    ];
  };
}
