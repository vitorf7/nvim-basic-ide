local M = {
	"goolord/alpha-nvim",
	event = "VimEnter",
}

function M.config()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")
	local logo = [[   
      ██╗      ██████╗ ██████╗ ██████╗     ██╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗███████╗
      ██║     ██╔═══██╗██╔══██╗██╔══██╗    ██║   ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝╚════██║
      ██║     ██║   ██║██████╔╝██║  ██║    ██║   ██║██║   ██║   ██║   ██║██████╔╝█████╗      ██╔╝
      ██║     ██║   ██║██╔══██╗██║  ██║    ╚██╗ ██╔╝██║   ██║   ██║   ██║██╔══██╗██╔══╝     ██╔╝ 
      ███████╗╚██████╔╝██║  ██║██████╔╝     ╚████╔╝ ██║   ██║   ╚██████╔╝██║  ██║██║        ██║  
      ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝       ╚═══╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝        ╚═╝  
    ]]

    dashboard.section.header.val = vim.split(logo, "\n")
	dashboard.section.buttons.val = {
		dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
		dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button(
			"p",
			" " .. " Find project",
			":lua require('telescope').extensions.projects.projects()<CR>"
		),
		dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope oldfiles <CR>"),
		dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
		dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
		dashboard.button("l", " " .. " Update Lazy Plugins", ":Lazy<CR>"),
		dashboard.button("u", " " .. " Update Mason", ":Mason<CR>"),
		dashboard.button("q", " " .. " Quit", ":qa<CR>"),
	}
	-- local function footer()
	-- 	return "Lord Vitor Faiante"
	-- end

	-- dashboard.section.footer.val = footer()

	-- dashboard.section.footer.opts.hl = "Type"
	-- dashboard.section.header.opts.hl = "Include"
	-- dashboard.section.buttons.opts.hl = "Keyword"

	-- dashboard.opts.opts.noautocmd = true

	for _, button in ipairs(dashboard.section.buttons.val) do
		button.opts.hl = "AlphaButtons"
		button.opts.hl_shortcut = "AlphaShortcut"
	  end
	  dashboard.section.header.opts.hl = "AlphaHeader"
	  dashboard.section.buttons.opts.hl = "AlphaButtons"
	  dashboard.section.footer.opts.hl = "AlphaFooter"
	  dashboard.opts.layout[1].val = 8
  
	  dashboard.opts.opts.noautocmd = true


	alpha.setup(dashboard.opts)
end

return M
