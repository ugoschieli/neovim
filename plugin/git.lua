local map = require("utils").map

local diffview = {
	enhanced_diff_hl = true,
	view = {
		merge_tool = {
			layout = "diff3_mixed",
		},
	},
}

local neogit = {
	graph_style = "kitty",
}

local gitsigns = {}

require("diffview").setup(diffview)
require("gitsigns").setup(gitsigns)
require("neogit").setup(neogit)
map("<leader>g", "<cmd>Neogit<cr>", "Open Neogit")
