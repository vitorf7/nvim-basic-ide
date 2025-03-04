local M = {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	lazy = false,
}

function M.config()
	require("mason-tool-installer").setup({
		-- a list of all tools you want to ensure are installed upon
		-- start; they should be the names Mason uses for each tool
		ensure_installed = {
			-- DAP
			"delve",
			"js-debug-adapter",
			"php-debug-adapter",

			-- Linter
			"buf", -- also a formatter
			"hadolint",
			"markdownlint", -- also a formatter
			"misspell",
			"phpcs",
			"tflint",
			"yamllint",
			"golangci-lint",
			"jsonlint",

			-- Formatter
			"gofumpt",
			"goimports",
			"golines",
			"prettier",
			"stylua",
			"yamlfmt",
			"black",
			"php-cs-fixer",
			"ts-standard",

			-- Other tools
			"gotests",
			"gomodifytags",
			"iferr",
			"impl",
			"gotestsum",
		},
		-- if set to true this will check each tool for updates. If updates
		-- are available the tool will be updated. This setting does not
		-- affect :MasonToolsUpdate or :MasonToolsInstall.
		-- Default: false
		auto_update = false,

		-- automatically install / update on startup. If set to false nothing
		-- will happen on startup. You can use :MasonToolsInstall or
		-- :MasonToolsUpdate to install tools and check for updates.
		-- Default: true
		run_on_start = true,

		-- set a delay (in ms) before the installation starts. This is only
		-- effective if run_on_start is set to true.
		-- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
		-- Default: 0
		start_delay = 3000, -- 3 second delay

		-- Only attempt to install if 'debounce_hours' number of hours has
		-- elapsed since the last time Neovim was started. This stores a
		-- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
		-- This is only relevant when you are using 'run_on_start'. It has no
		-- effect when running manually via ':MasonToolsInstall' etc....
		-- Default: nil
		debounce_hours = 5, -- at least 5 hours between attempts to install/update
	})
end

return M
