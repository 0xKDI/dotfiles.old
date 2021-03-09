require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		bash,
		go,
		json,
		lua,
		python,
		css,
		html,
		nix
	},
	highlight = {
		enable = true
	},
}
