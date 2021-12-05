require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained", 
	ignore_install = { "kotlin", "java" },
	highlight = {
		enable = true,
		disable = { "kotlin", "java" },
	},
}
