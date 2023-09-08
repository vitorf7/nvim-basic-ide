local M = {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre" },
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
		},
		{
			"olexsmir/gopher.nvim",
		},
		{ "folke/neodev.nvim", opts = {} },
		{
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				{
					"SmiteshP/nvim-navic",
				},
				"MunifTanjim/nui.nvim",
			},
			opts = { lsp = { auto_attach = true } },
		},
	},
	keys = {
		{ "<leader>ln", "<cmd>Navbuddy<CR>", desc = "Navbuddy" },
	},
}

local cmp_nvim_lsp = require("cmp_nvim_lsp")
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(
		bufnr,
		"n",
		"gd",
		"<cmd>lua require('telescope.builtin').lsp_definitions(require('telescope.themes').get_dropdown())<CR>",
		opts
	)
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	keymap(
		bufnr,
		"n",
		"gi",
		"<cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_dropdown())<cr>",
		opts
	)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "glr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	keymap(
		bufnr,
		"n",
		"gr",
		"<cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown())<cr>",
		opts
	)
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	keymap(
		bufnr,
		"n",
		"gca",
		"<cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_dropdown())<cr>",
		opts
	)
	keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

local function setup_codelens_refresh(client, bufnr)
	local status_ok, codelens_supported = pcall(function()
		return client.supports_method("textDocument/codeLens")
	end)
	if not status_ok or not codelens_supported then
		return
	end
	local group = "lsp_code_lens_refresh"
	local cl_events = { "BufEnter", "BufNew", "InsertLeave" }
	local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
		group = group,
		buffer = bufnr,
		event = cl_events,
	})

	if ok and #cl_autocmds > 0 then
		return
	end
	vim.api.nvim_create_augroup(group, { clear = false })
	vim.api.nvim_create_autocmd(cl_events, {
		group = group,
		buffer = bufnr,
		callback = vim.lsp.codelens.refresh,
	})
end

function M.on_attach(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
		vim.keymap.set(
			"n",
			"<leader>lo",
			"<cmd>TSToolsOrganizeImports<cr>",
			{ buffer = bufnr, desc = "Organize Imports" }
		)
		vim.keymap.set("n", "<leader>lO", "<cmd>TSToolsSortImports<cr>", { buffer = bufnr, desc = "Sort Imports" })
		vim.keymap.set("n", "<leader>lu", "<cmd>TSToolsRemoveUnused<cr>", { buffer = bufnr, desc = "Removed Unused" })
		vim.keymap.set(
			"n",
			"<leader>lz",
			"<cmd>TSToolsGoToSourceDefinition<cr>",
			{ buffer = bufnr, desc = "Go To Source Definition" }
		)
		vim.keymap.set(
			"n",
			"<leader>lR",
			"<cmd>TSToolsRemoveUnusedImports<cr>",
			{ buffer = bufnr, desc = "Removed Unused Imports" }
		)
		vim.keymap.set("n", "<leader>lF", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr, desc = "Fix All" })
		vim.keymap.set(
			"n",
			"<leader>lA",
			"<cmd>TSToolsAddMissingImports<cr>",
			{ buffer = bufnr, desc = "Add Missing Imports" }
		)
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)
	require("illuminate").on_attach(client)
	-- nvim-navic
	if client.server_capabilities.documentSymbolProvider then
		local navic = require("nvim-navic")
		navic.attach(client, bufnr)
	end

	setup_codelens_refresh(client, bufnr)
end

function M.config()
	require("neodev").setup({
		library = { plugins = { "neotest" }, types = true },
	})

	local lspconfig = require("lspconfig")

	for _, server in pairs(require("utils").servers) do
		local opts = {
			on_attach = M.on_attach,
			capabilities = M.capabilities,
		}

		server = vim.split(server, "@")[1]

		local require_ok, settings = pcall(require, "settings." .. server)
		if require_ok then
			opts = vim.tbl_deep_extend("force", opts, settings)
		end

		lspconfig[server].setup(opts)
	end

	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = true,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
			suffix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

return M
