local M = {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
}

M.opts = {
	-- char = "▏",
	char = "│",
	filetype_exclude = {
		"help",
		"alpha",
		"dashboard",
		"neo-tree",
		"Trouble",
		"packer",
		"lazy",
		"mason",
		"notify",
		"toggleterm",
		"lazyterm",
	},
	show_trailing_blankline_indent = false,
	show_current_context = true,
	show_first_indent_level = true,
	use_treesitter = true,
	buftype_exclude = { "terminal", "nofile" },
}

return M
