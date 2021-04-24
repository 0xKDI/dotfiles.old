vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.formatoptions="tcqjr"
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.mouse = "a"
vim.o.cursorline = true
vim.o.showmode = false
vim.o.swapfile = false
vim.o.hidden = true
vim.o.t_Co = "256"
vim.o.termguicolors = true


-- Update sign column every 1/4 second
vim.o.updatetime = 250

vim.o.langmap="ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

vim.o.lazyredraw = true -- fix slow scrolling

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.expandtab = true
-- vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 10

-- netrw
vim.g.netrw_banner = false
vim.g.netrw_home = vim.env.XDG_CACHE_HOME ..'/nvim'
vim.g.netrw_winsize = 30


vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<leader>=', '<C-W>=', { noremap = true })

-- resize 
vim.api.nvim_set_keymap('n', '<C-left>', ':vertical resize +3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize -3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', ':close<CR> ', { noremap = true })
vim.api.nvim_set_keymap('n', '\\', '/', { noremap = true })

-- tabs
vim.api.nvim_set_keymap('n', '<leader>]', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>[', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', ':tabnew %<CR>', { noremap = true, silent = true })



vim.api.nvim_set_keymap('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })


-- visual
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Change Y to copy to end of line and behave like C
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- switch to n-th tab with leader + n
vim.api.nvim_set_keymap('n', '<leader>1', '1gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', '2gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', '3gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', '4gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>5', '5gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>6', '6gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>7', '7gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>8', '8gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>9', '9gt', { noremap = true, silent = true })

-- Faster up/down movement
vim.api.nvim_set_keymap('', '<C-j>', '8j', { silent = true })
vim.api.nvim_set_keymap('', '<C-k>', '8k', { silent = true })


vim.api.nvim_exec([[
    if !&scrolloff
        set scrolloff=3
    endif
]], false)

vim.api.nvim_exec([[
    autocmd FileType plaintex set filetype=tex
    autocmd FileType yaml set tabstop=2 shiftwidth=2
    autocmd FileType helm set tabstop=2 shiftwidth=2
    autocmd FileType help wincmd L
    autocmd BufNewFile,BufRead buku-edit-* set filetype=conf
    autocmd BufNewFile,BufRead .envrc set filetype=sh
]], false)

vim.api.nvim_exec([[
    " need 5.0 version
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=100}
    augroup END
]], false)
