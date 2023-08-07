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

require("lazy").setup({
  -- My plugins here
  -- Colorschemes (mine)
  'shaunsingh/nord.nvim',
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },

  -- Dap
  'theHamsta/nvim-dap-virtual-text',
  'nvim-telescope/telescope-dap.nvim',

  -- Golang
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",

  -- JavaScript / TypeScript
  "mxsdev/nvim-dap-vscode-js",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function(_, opts)
      require("typescript-tools").setup(opts)
    end,
  },

  -- Navigate between vim and tmux splits
  { "alexghergh/nvim-tmux-navigation" },

  -- Waka Time
  "wakatime/vim-wakatime",

  -- Notification
  "rcarriga/nvim-notify",

  -- Which Key
  { "folke/which-key.nvim" },

  -- LSP (mine)
  {"j-hui/fidget.nvim", tag = "legacy"},

  -- Smooth Scrolling
  "karb94/neoscroll.nvim",

  -- Codeium
  "Exafunction/codeium.vim",

  { "wbthomason/packer.nvim" }, -- Have packer manage itself
  { "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
  { "windwp/nvim-autopairs" }, -- Autopairs, integrates with both cmp and treesitter
  { "numToStr/Comment.nvim" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352" },
  { "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" },
  { "akinsho/bufferline.nvim" },
  { "moll/vim-bbye" },
  { "nvim-lualine/lualine.nvim" },
  { "akinsho/toggleterm.nvim" },
  { "ahmedkhalf/project.nvim" },
  { "lewis6991/impatient.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "goolord/alpha-nvim" },

  -- Colorschemes
  { "folke/tokyonight.nvim" },
  { "lunarvim/darkplus.nvim" },

  -- cmp plugins
  { "hrsh7th/nvim-cmp" }, -- The completion plugin
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "hrsh7th/cmp-path" }, -- path completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },

  -- snippets
  { "L3MON4D3/LuaSnip" }, --snippet engine
  { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

  -- LSP
  -- { "williamboman/nvim-lsp-installer" }, -- simple to language server installer
  { "neovim/nvim-lspconfig" }, -- enable LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
  { "RRethy/vim-illuminate" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  --
  -- { "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" }, -- simple to language server installer
  -- { "neovim/nvim-lspconfig", commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda" }, -- enable LSP
  -- { "williamboman/mason.nvim", commit = "bfc5997e52fe9e20642704da050c415ea1d4775f" },
  -- { "williamboman/mason-lspconfig.nvim", commit = "0eb7cfefbd3a87308c1875c05c3f3abac22d367c" },
  -- { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" }, -- for formatters and linters
  -- { "RRethy/vim-illuminate", commit = "a2e8476af3f3e993bb0d6477438aad3096512e42" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim"
    },
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter" },

  -- Git
  { "lewis6991/gitsigns.nvim" },

  -- DAP
  { "mfussenegger/nvim-dap"},
  { "rcarriga/nvim-dap-ui"},
  { "ravenxrz/DAPInstall.nvim"},

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
  },

  -- noicer ui
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
  },
})
