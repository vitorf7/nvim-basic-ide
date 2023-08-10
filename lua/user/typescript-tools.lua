local M = {
    "pmizio/typescript-tools.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
    },
}

M.opts = {}

function M.config()
    require("typescript-tools").setup(M.opts)
end

return M