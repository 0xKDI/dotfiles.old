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



vim.api.nvim_set_keymap('n', '<leader>=', '<C-W>=', { noremap = true })


vim.api.nvim_set_keymap('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:h<CR>', { noremap = true })


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
vim.api.nvim_set_keymap('', '<C-j>', '8j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<C-k>', '8k', { noremap  = true, silent = true })


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
    autocmd BufNewFile,BufRead .envrc set filetype=sh
    autocmd BufNewFile,BufRead *.nix set filetype=nix
    augroup ansible_vim_fthosts
      autocmd!
      autocmd BufNewFile,BufRead */tasks/*.yml setfiletype yaml.ansible
      autocmd BufNewFile,BufRead */handlers/*.yml setfiletype yaml.ansible
      autocmd BufNewFile,BufRead */default/*.yml setfiletype yaml.ansible
    augroup END
]], false)

vim.api.nvim_exec([[
    " need 5.0 version
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=100}
    augroup END
]], false)
