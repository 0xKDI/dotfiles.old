set clipboard+=unnamedplus
set ignorecase
set smartcase
set formatoptions-=o
set formatoptions+=rj
set relativenumber
set number
set mouse=a
set cursorline
set noshowmode
set noswapfile
set hidden
set t_Co=256
set termguicolors
if !&scrolloff
    set scrolloff=3
endif
set updatetime=300
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

set lazyredraw " fix slow scrolling

" tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType plaintex set filetype=tex
" autocmd FileType tex set tabstop=3 shiftwidth=3 softtabstop=3
autocmd FileType yaml set tabstop=2 shiftwidth=2
autocmd FileType helm set tabstop=2 shiftwidth=2
autocmd FileType help wincmd L

" for buku -w
autocmd BufNewFile,BufRead buku-edit-* set filetype=conf
autocmd BufNewFile,BufRead .envrc set filetype=sh

set expandtab
" set smartindent
set splitbelow
set splitright
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

let mapleader = " "

" resize 
nnoremap <leader>= <C-W>=
nnoremap <silent> <C-left> :vertical resize +3<CR>
nnoremap <silent> <C-Right> :vertical resize -3<CR>
nnoremap <silent> <C-Up> :resize +3<CR>
nnoremap <silent> <C-Down> :resize -3<CR>

nnoremap <leader>d :close<CR> 
nnoremap \ /

" tabs
nnoremap <silent> <leader>] :tabnext<CR>
nnoremap <silent> <leader>[ :tabprevious<CR>
nnoremap <silent> <leader>b :tabnew %<CR>


" Move highlighted stuff up down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" visual
vmap < <gv 
vmap > >gv

" Change Y to copy to end of line and behave like C
nnoremap Y y$

" switch to n-th tab with leader + n
nnoremap <silent> <leader>1 1gt
nnoremap <silent> <leader>2 2gt
nnoremap <silent> <leader>3 3gt
nnoremap <silent> <leader>4 4gt
nnoremap <silent> <leader>5 5gt
nnoremap <silent> <leader>6 6gt
nnoremap <silent> <leader>7 7gt
nnoremap <silent> <leader>8 8gt
nnoremap <silent> <leader>9 9gt
nnoremap <silent> <leader>9 9gt

" Faster up/down movement
map <C-j> 8j
map <C-k> 8k
