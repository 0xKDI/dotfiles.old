vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.formatoptions="tcqjr"
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.mouse = "a"
vim.wo.cursorline = true
vim.o.showmode = false
vim.o.swapfile = false
vim.o.hidden = true
-- vim.o.t_Co = "256"
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

-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

