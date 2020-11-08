call plug#begin('~/.local/share/nvim/plugged')
" GOD BLESS
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
" @lsp
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'steelsojka/completion-buffers'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'
Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'sheerun/vim-polyglot'
Plug 'ryanoasis/vim-devicons'
" Plug 'yuttie/comfortable-motion.vim'
Plug 'tommcdo/vim-lion'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'itchyny/lightline.vim'
Plug 'norcalli/nvim-colorizer.lua'
" @snippets
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Plug 'plasticboy/vim-markdown'
call plug#end()
