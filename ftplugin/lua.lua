local opts = {
	library = {
		{ path = "luvit-meta/library", words = { "vim%.uv" } },
	},
}

require("lazydev").setup(opts)
