local M = {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown", "md" },
	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreview<CR>", desc = "Markdown Preview" },
	},
}

function M.build()
	vim.fn["mkdp#util#install"]()
end

function M.config()
	vim.g.mkdp_theme = "light"
	vim.g.mkdp_auto_start = 0
	vim.g.mkdp_auto_close = 1
end

return M
