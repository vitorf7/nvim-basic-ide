local M = {
	"rcarriga/nvim-notify",
	lazy = false,
}

function M.config()
	require("notify").setup({
		stages = "slide",
	})
end

return M
