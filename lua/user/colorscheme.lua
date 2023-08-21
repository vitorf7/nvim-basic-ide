local M = {
	"catppuccin/nvim",
  lazy = true,
  event = "VimEnter",
}

M.name = "catppuccin"
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
function M.config()
	local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
	if not status_ok then
		return
	end

	require("catppuccin").setup()
end

return M
