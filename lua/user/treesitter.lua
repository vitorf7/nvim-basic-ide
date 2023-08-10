local M = {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "VeryLazy",
		},
		{
			"nvim-tree/nvim-web-devicons",
			event = "VeryLazy",
		},
	},
}
function M.config()
	local treesitter = require("nvim-treesitter")
	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = require("utils").parsers, -- put the language you want in this array
		ignore_install = { "" }, -- List of parsers to ignore installing
		sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

		highlight = {
			enable = true, -- false will disable the whole extension
		},
		indent = { enable = true, disable = { "python", "css" } },

		autopairs = {
			enable = true,
		},
		autotag = { -- require autotag plugin
			enable = true,
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	})
end

return M
