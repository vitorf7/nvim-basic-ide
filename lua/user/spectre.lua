local M = {
	"windwp/nvim-spectre",
	lazy = false,
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
}

return M
