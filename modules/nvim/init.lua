vim.api.nvim_set_keymap('n', 'Q', ':bd<CR>', { noremap = true, silent = true })
-- resize 
vim.api.nvim_set_keymap('n', '<C-left>', ':vertical resize +3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize -3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -3<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>d', ':close<CR> ', { noremap = true })
vim.api.nvim_set_keymap('n', '\\', '/', { noremap = true })


-- tabs
vim.api.nvim_set_keymap('n', '<space>]', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>[', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>t', ':tabnew %<CR>', { noremap = true, silent = true })



vim.api.nvim_set_keymap('n', '<space>=', '<C-W>=', { noremap = true })


vim.api.nvim_set_keymap('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.api.nvim_set_keymap('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })


-- visual
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Change Y to copy to end of line and behave like C
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- switch to n-th tab with space + n
vim.api.nvim_set_keymap('n', '<space>1', '1gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>2', '2gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>3', '3gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>4', '4gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>5', '5gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>6', '6gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>7', '7gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>8', '8gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>9', '9gt', { noremap = true, silent = true })

vim.api.nvim_exec([[
    if !&scrolloff
        set scrolloff=3
    endif
]], false)

vim.api.nvim_exec([[
    autocmd FileType plaintex set filetype=tex
    autocmd FileType plaintex set filetype=tex
    autocmd FileType yaml set tabstop=2 shiftwidth=2
    autocmd FileType helm set tabstop=2 shiftwidth=2 commentstring=#%s
    autocmd FileType help wincmd L
    autocmd BufNewFile,BufRead .envrc set filetype=sh
    autocmd BufNewFile,BufRead *.nix set filetype=nix
    autocmd BufNewFile,BufRead ~/.kube/config set filetype=yaml
    autocmd BufNewFile,BufRead *.gotmpl setfiletype helm
    autocmd BufNewFile,BufRead helmfile*.yaml setfiletype helm
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
