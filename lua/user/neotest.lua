return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-neotest/neotest-vim-test",
		"vim-test/vim-test",
		"nvim-neotest/neotest-go",
	},
	-- keys = {
	-- 	{
	-- 		"<leader>tF",
	-- 		"<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
	-- 		desc = "Debug File",
	-- 	},
	-- 	{ "<leader>tL", "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
	-- 	{ "<leader>ta", "<cmd>w|lua require('neotest').run.attach()<cr>", desc = "Attach" },
	-- 	{ "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
	-- 	{ "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>", desc = "Last" },
	-- 	{ "<leader>tn", "<cmd>w|lua require('neotest').run.run()<cr>", desc = "Nearest" },
	-- 	{ "<leader>tN", "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
	-- 	{ "<leader>to", "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
	-- 	{ "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>", desc = "Stop" },
	-- 	{ "<leader>tS", "<cmd>w|lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
	-- },
	config = function()
		local status_ok, which_key = pcall(require, "which-key")
		if not status_ok then
			return
		end
		local opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		}
		which_key.register({
			t = {
				name = "Neotest",
				F = {
					"<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
					"Debug File",
				},
				L = { "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>", "Debug Last" },
				a = { "<cmd>w|lua require('neotest').run.attach()<cr>", "Attach" },
				f = { "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "File" },
				l = { "<cmd>w|lua require('neotest').run.run_last()<cr>", "Last" },
				n = { "<cmd>w|lua require('neotest').run.run()<cr>", "Nearest" },
				N = { "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
				o = { "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>", "Output" },
				s = { "<cmd>w|lua require('neotest').run.stop()<cr>", "Stop" },
				S = { "<cmd>w|lua require('neotest').summary.toggle()<cr>", "Summary" },
			},
		}, opts)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)
		require("neotest").setup({
			diagnostic = {
				enabled = true,
			},
			status = {
				virtual_text = true,
				signs = true,
			},
			output = {
				open_on_run = true,
			},
			strategies = {
				integrated = {
					width = 180,
				},
			},
			adapters = {
				require("neotest-vim-test")({
					ignore_file_types = { "python", "vim", "lua" },
				}),
				require("neotest-go")({}),
			},
		})
	end,
}
