vim.g.tmux_navigator_no_mappings = 1
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<M-h>', ':TmuxNavigateLeft<cr>', opts)
vim.api.nvim_set_keymap('n', '<M-j>', ':TmuxNavigateDown<cr>', opts)
vim.api.nvim_set_keymap('n', '<M-k>', ':TmuxNavigateUp<cr>', opts)
vim.api.nvim_set_keymap('n', '<M-l>', ':TmuxNavigateRight<cr>', opts)
vim.api.nvim_set_keymap('n', '<M-\\>', ':TmuxNavigatePrevious<cr>', opts)
