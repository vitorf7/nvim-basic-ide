local M = {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = {
		{
			"nvim-lua/plenary.nvim",
		},
		{
			"jay-babu/mason-null-ls.nvim",
			opts = {
				automatic_setup = true,
				ensure_installed = require("utils").linters,
				automatic_installation = true,
			},
		},
	},
}

function M.config()
	local null_ls = require("null-ls")
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
	local formatting = null_ls.builtins.formatting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
	local diagnostics = null_ls.builtins.diagnostics

	-- https://github.com/prettier-solidity/prettier-plugin-solidity
	null_ls.setup({
		debug = false,
		sources = {
			formatting.prettier.with({
				extra_filetypes = { "toml" },
				extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
			}),
			formatting.black.with({ extra_args = { "--fast" } }),
			formatting.stylua,
			formatting.google_java_format,
			formatting.buf,
			formatting.gofumpt,
			formatting.goimports,
			diagnostics.flake8,
			diagnostics.hadolint,
		},
	})
end

return M
