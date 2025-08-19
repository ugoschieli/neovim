local map = require("utils").map
local t = require("telescope.builtin")

map("<leader>fh", t.help_tags, "Find help")
map("<leader>fk", t.keymaps, "Find keymap")
map("<leader>fw", t.grep_string, "Find current word")
map("<leader>fg", t.live_grep, "Live grep")
map("<leader>fr", t.resume, "Resume last search")
map("<leader>fs", t.lsp_document_symbols, "Find LSP document symbol")
map("<leader>fS", t.lsp_workspace_symbols, "Find LSP workspace symbol")
map("<leader>fd", t.diagnostics, "Find diagnostic")
map("<leader>f.", t.oldfiles, "Find recent file")
map("<leader><leader>", t.buffers, "Find open buffer")

map("<leader>fm", function()
	t.man_pages({ sections = { "All" } })
end, "Find Man pages")

map("<leader>ff", function()
	t.find_files({ hidden = true })
end, "Find files")

map("<leader>fa", function()
	t.find_files({ hidden = true, no_ignore = true })
end, "Find all files")

local opts = {
	defaults = {
		file_ignore_patterns = { "^.git" },
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			hidden = true,
		},
		buffers = {
			sort_lastused = true,
			sort_mru = true,
			ignore_current_buffer = true,
			mappings = {
				i = {
					["<C-d>"] = "delete_buffer",
				},
			},
		},
	},
}

require("telescope").setup(opts)
require("telescope").load_extension("fzf")
