local M = {
    "olexsmir/gopher.nvim",
    lazy = false,
}

function M.config()
    require("gopher").setup({
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "gotests",
          impl = "impl",
          iferr = "iferr",
        },
    })
end

return M