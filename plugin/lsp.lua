local lsp = require("utils.lsp")
require("fidget").setup({})

local servers = {
	clangd = {},
	cssls = {},
	dockerls = {},
	docker_compose_language_service = {},
	emmet_language_server = {},
	eslint = {},
	gopls = {},
	hls = {
		filetypes = { "haskell", "lhaskell", "cabal" },
	},
	html = {},
	lua_ls = {},
	rust_analyzer = {},
	tailwindcss = {},
	ts_ls = {},
	jsonls = {},
}

for server, config in pairs(servers) do
	lsp.setup_server(server, config)
end
