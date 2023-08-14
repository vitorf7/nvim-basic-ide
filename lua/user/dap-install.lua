local M = {
	"ravenxrz/DAPInstall.nvim",
}

function M.config()
	require("dap-install").setup({})
	require("dap-install").config("python", {})
end

return M
