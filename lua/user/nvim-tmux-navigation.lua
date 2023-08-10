local M = {
	"alexghergh/nvim-tmux-navigation",
	lazy = false,
}

function M.config()
	require("nvim-tmux-navigation").setup({
		disable_when_zoomed = true, -- defaults to false
	})
end

return M
