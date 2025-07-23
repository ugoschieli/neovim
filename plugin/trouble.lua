local map = require("utils").map

local opts = {
	auto_focus = true,
}

require("trouble").setup(opts)
map("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
map("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
map("<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)")
map(
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	"LSP Definitions / references/ ... (Trouble)"
)
map("<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
map("<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")
