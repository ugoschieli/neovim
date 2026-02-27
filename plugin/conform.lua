local opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		javascript = { "biome-check" },
		typescript = { "biome-check" },
		javascriptreact = { "biome-check" },
		typescriptreact = { "biome-check" },
		html = { "biome-check" },
		css = { "biome-check" },
		json = { "biome-check" },
		jsonc = { "biome-check" },
		vue = { "biome-check" },
	},
	formatters = {
		["clang-format"] = {
			prepend_args = { "--sort-includes=0", "--style=webkit" },
		},
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

require("conform").setup(opts)
