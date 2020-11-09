" defaults
set clipboard+=unnamedplus
set ignorecase
set smartcase
set formatoptions-=o
set relativenumber
set number
set mouse=a
set cursorline
set noshowmode
set noswapfile
set t_Co=256
set termguicolors
if !&scrolloff
    set scrolloff=3
endif
set updatetime=300
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
autocmd FileType plaintex set filetype=tex
" autocmd FileType tex set tabstop=3 shiftwidth=3 softtabstop=3
autocmd FileType help wincmd L
" for buku -w
autocmd BufNewFile,BufRead buku-edit-* set filetype=conf
" tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" set smartindent
" splits
set splitbelow
set splitright
" folds
set foldmethod=syntax
set foldlevelstart=99
set foldnestmax=10

" need 5.0 version
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=100}
augroup END


" netrw
let g:netrw_banner = 0
let g:netrw_home=$XDG_CACHE_HOME.'/nvim'
let g:netrw_winsize = 30




" " nvim-lspconfig
" autocmd BufEnter * lua require'completion'.on_attach()
" " Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" " Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect




" Avoid showing message extra message when using completion
" set shortmess+=c
" FIXME
" lua require'nvim_lsp'.gopls.setup{}



" TODO
" completion-buffers
" let g:completion_chain_complete_list = [
"     \{'complete_items': ['snippets', 'lsp', 'buffers']},
"     \{'mode': '<c-n>'}
" \]
" let g:completion_enable_snippet = 'UltiSnips'





" nvim-colorizer
" lua require'colorizer'.setup()

let mapleader = " "

" windows
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
" moving
nnoremap <leader><leader>h <C-w>H
nnoremap <leader><leader>j <C-w>J
nnoremap <leader><leader>k <C-w>K
nnoremap <leader><leader>l <C-w>L
nnoremap <leader><leader>r <C-W>r
" resize 
nnoremap <leader>= <C-W>=
nnoremap <silent> <C-left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>

nnoremap <leader>d :close<CR> 

" tabs
nnoremap <silent> <leader>tk :tabclose<CR>
nnoremap <silent> <leader>tf :tabfind %<CR>
nnoremap <silent> <leader>] :tabnext<CR>
nnoremap <silent> <leader>[ :tabprevious<CR>

" buffers
nnoremap <silent> <leader>bk :bdelete<CR>


" Move highlighted stuff up down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" open new file in vertical split
nnoremap <leader>fn :vs 

" visual
vmap < <gv 
vmap > >gv

" Change Y to copy to end of line and behave like C
nnoremap Y y$

