vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"lua",
		"nix",
		"json",
		"html",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"haskell",
	},
	callback = function(_)
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml" },
	callback = function(_)
		local filename = vim.fn.expand("%:t")
		if
			filename == "compose.yml"
			or filename == "compose.yaml"
			or filename == "docker-compose.yml"
			or filename == "docker-compose.yaml"
		then
			vim.bo.filetype = "yaml.docker-compose"
		end
	end,
})
