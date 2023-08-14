local M = {
	"rcarriga/nvim-notify",
}

vim.opt.termguicolors = true
function M.config()
	require("notify").setup({
		stages = "slide",
	})
	vim.notify = require("notify")
end

return M
