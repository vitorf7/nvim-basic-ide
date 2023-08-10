local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- example using a list of specs with the default options
vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct

-- load lazy
require("lazy").setup("user", {
	install = {
		missing = true,
		colorscheme = { require("user.colorscheme").name },
	},
	defaults = { lazy = true },
	ui = {
		wrap = "true",
		border = "rounded",
	},
	checker = {
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
	change_detection = {
		enabled = true,
		notify = false, -- get a notification when changes are found
	},
	debug = false,
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			disabled_plugins = {
				-- "gzip", -- Plugin for editing compressed files.
				-- "matchit", -- What is it?
				--  "matchparen", -- Plugin for showing matching parens
				--  "netrwPlugin", -- Handles file transfers and remote directory listing across a network
				--  "tarPlugin", -- Plugin for browsing tar files
				--  "tohtml", -- Converting a syntax highlighted file to HTML
				--  "tutor", -- Teaching?
				--  "zipPlugin", -- Handles browsing zipfiles
			},
		},
	},
	readme = {
		enabled = true,
		root = vim.fn.stdpath("state") .. "/lazy/readme",
		files = { "README.md", "lua/**/README.md" },
		skip_if_doc_exists = true,
	},
	state = vim.fn.stdpath("state") .. "/lazy/state.json", -- state info for checker and other things
})
