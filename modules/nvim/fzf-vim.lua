-- TODO: add fzf function for cd
-- https://github.com/junegunn/fzf/wiki/Examples-(vim)
-- vim.g.fzf_layout = { 'window' = { 'width' = '0.8'; 'height' = '0.6' }; }

vim.api.nvim_exec([[
    autocmd! FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
]], false)

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<leader>ff', ':Files!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', ':History!<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>,', ':Windows!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>w', ':Buffers!<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>p', ':cd ', opts)

vim.api.nvim_set_keymap('n', '<leader>/', ':BLines!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>?', ':Lines!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><leader>/', ':History/!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>;', ':Commands!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader><CR>', ':Marks!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>r', ':Rg!', opts)
vim.api.nvim_set_keymap('n', '<leader>gf', ':GFiles!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gc', ':Commits!<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gbc', ':BCommits!<CR>', opts)
