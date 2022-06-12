require'nvim-treesitter.configs'.setup {
	ensure_installed = "all", 
	ignore_install = { "kotlin", "java" },
	highlight = {
		enable = true,
		disable = { "kotlin", "java" },
	},
}
