-- TODO: add fzf function for cd
-- https://github.com/junegunn/fzf/wiki/Examples-(vim)
-- vim.g.fzf_layout = { 'window' = { 'width' = '0.8'; 'height' = '0.6' }; }

vim.api.nvim_exec([[
    autocmd! FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
]], false)

vim.api.nvim_set_keymap('n', '<leader>f', ':Files!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':History!<CR>', { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>,', ':Windows!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers!<CR>', { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>p', ':cd %:p:h <CR>:pwd<CR>', { noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>/', ':BLines!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>?', ':Lines!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader><leader>/', ':History/!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>;', ':Commands!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader><CR>', ':Marks!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>r', ':Rg!', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gf', ':GFiles!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ':Commits!<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gbc', ':BCommits!<CR>', { noremap = true, silent = true})
