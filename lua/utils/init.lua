local M = {}

M.servers = {
	"lua_ls",
	"cssls",
	"html",
	"tsserver",
	"eslint",
	"pyright",
	"bashls",
	"jsonls",
	"yamlls",
	"gopls",
	"phpactor",
	"intelephense",
	"terraformls",
	"tflint",
	"bufls",
	"cucumber_language_server",
	"dockerls",
	"marksman",
	"dockerls",
	"golangci_lint_ls",
}

M.linters = {
	"buf",
	"hadolint",
	"markdownlint",
	"misspell",
	"phpcs",
	"tflint",
	"yamllint",
	"prettier",
	"stylua",
}

M.parsers = {
	"bash",
	"cmake",
	"css",
	"dockerfile",
	"dot",
	"hcl",
	"html",
	"http",
	"javascript",
	"json",
	"json5",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"php",
	"phpdoc",
	"proto",
	"python",
	"query",
	"scss",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vue",
	"yaml",
	"terraform",
	"go",
	"godot_resource",
	"gomod",
	"gosum",
	"gowork",
}

function M.exists(list, val)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set[val]
end

function M.log(msg, hl, name)
	name = name or "Neovim"
	hl = hl or "Todo"
	vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name })
end

function M.is_empty(s)
	return s == nil or s == ""
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

function M.quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("q!")
			end
		end)
	else
		vim.cmd("q!")
	end
end

return M
