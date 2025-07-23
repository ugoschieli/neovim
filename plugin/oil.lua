local map = require("utils").map

local opts = {
	view_options = {
		show_hidden = true,
	},
}

require("oil").setup(opts)
map("<leader>e", "<cmd>Oil<cr>", "Open Oil")
