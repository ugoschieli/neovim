local M = {}

---Keymap utility function
---@param rhs string
---@param lhs string|function
---@param desc string
---@param mode string?
---@param opts vim.keymap.set.Opts?
function M.map(rhs, lhs, desc, mode, opts)
	mode = mode or "n"
	opts = opts or {}
	vim.keymap.set(mode, rhs, lhs, vim.tbl_extend("force", opts, { desc = desc, noremap = true, silent = true }))
end

--- return a list of all the keys in the provided table
---@param t table
---@return table
function M.keys(t)
	local key_t = {}
	for key, _ in pairs(t) do
		table.insert(key_t, key)
	end
	return key_t
end

return M
