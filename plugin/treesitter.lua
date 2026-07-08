-- Treesitter highlighting configuration
-- Find the nvim-treesitter parser directory from runtimepath
local parser_dir = nil
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
	if path:match("nvim%-treesitter") then
		local potential_parser_dir = path .. "/runtime"
		if vim.fn.isdirectory(potential_parser_dir) == 1 then
			parser_dir = potential_parser_dir
			break
		end
	end
end

-- Configure treesitter to use the Nix-installed parsers
if parser_dir then
	require("nvim-treesitter").setup({
		install_dir = parser_dir,
	})
end

-- Create autocommands to enable treesitter for each filetype
local treesitter_group = vim.api.nvim_create_augroup("TreesitterEnable", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = treesitter_group,
	pattern = "*",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		pcall(vim.treesitter.start, buf)

		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.wo.foldlevel = 99
	end,
	desc = "Enable treesitter highlighting for all filetypes",
})

-- Configure nvim-ts-autotag separately
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	},
})

-- Textobjects configuration (nvim-treesitter-textobjects plugin is currently disabled)
-- Uncomment this block and enable the plugin in nix/neovim-overlay.nix if you want textobjects
--[[ require("nvim-treesitter.configs").setup({
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
			},
		},
	},
}) ]]
