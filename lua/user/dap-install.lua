local M = {
    "ravenxrz/DAPInstall.nvim",
    lazy = false,
    config = function()
      require("dap-install").setup {}
      require("dap-install").config("python", {})
    end,
  }
  
  return M