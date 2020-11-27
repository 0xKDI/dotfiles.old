vim.cmd('packadd! nvim-lspconfig')
require'nvim_lsp'.pyls.setup{}
require'nvim_lsp'.rnix.setup{}
require'nvim_lsp'.texlab.setup{
	settings = {
		latex = {
			lint = {
				onSave = false;
				onChange = false;
			}
		}
	}
}
require'nvim_lsp'.yamlls.setup{}
