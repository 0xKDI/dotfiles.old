vim.cmd('packadd! nvim-lspconfig')
function dummy()
	print 'hi'
end
local lspconfig = require'nvim_lsp'
lspconfig.pyls.setup{}
lspconfig.rnix.setup{}
lspconfig.yamlls.setup{}
