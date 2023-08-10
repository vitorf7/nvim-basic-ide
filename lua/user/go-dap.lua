local M = {
	"leoluz/nvim-dap-go",
	event = "VeryLazy",
}

function M.config()
	require("dap-go").setup()
end

return M
