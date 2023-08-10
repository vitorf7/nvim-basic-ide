local M = {
  "nvim-treesitter/nvim-treesitter",
  event = "BufReadPost",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
    {
      "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
    },
  },
}
function M.config()
  local treesitter = require "nvim-treesitter"
  local configs = require "nvim-treesitter.configs"

  configs.setup {
    ensure_installed = {
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
    }, -- put the language you want in this array
    -- ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { "" },                                                       -- List of parsers to ignore installing
    sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)

    highlight = {
      enable = true,       -- false will disable the whole extension
      disable = { "css" }, -- list of language that will be disabled
    },
    autopairs = {
      enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  }
end

return M
