local M = {
	"j-hui/fidget.nvim",
	tag = "legacy",
	lazy = false,
}

function M.config()
	require("fidget").setup()
end

return M
