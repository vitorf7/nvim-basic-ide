-- Using Lualine as the statusline.

-- Show git status.
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- Get the current buffer's filetype.
local function get_current_filetype()
  return vim.api.nvim_buf_get_option(0, "filetype")
end

-- Get the current buffer's type.
local function get_current_buftype()
  return vim.api.nvim_buf_get_option(0, "buftype")
end

-- Get the buffer's filename.
local function get_current_filename()
  local bufname = vim.api.nvim_buf_get_name(0)
  return bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
end

-- Gets the current buffer's filename with the filetype icon supplied
-- by devicons.
local M = require("lualine.components.filetype"):extend()
Icon_hl_cache = {}
local lualine_require = require "lualine_require"
local modules = lualine_require.lazy_require {
  highlight = "lualine.highlight",
  utils = "lualine.utils.utils",
}

-- Return the current buffer's filetype icon with highlighting.
function M:get_current_filetype_icon()
  -- Get setup.
  local icon, icon_highlight_group
  local _, devicons = pcall(require, "nvim-web-devicons")
  local f_name, f_extension = vim.fn.expand "%:t", vim.fn.expand "%:e"
  f_extension = f_extension ~= "" and f_extension or vim.bo.filetype
  icon, icon_highlight_group = devicons.get_icon(f_name, f_extension)

  -- Fallback settings.
  if icon == nil and icon_highlight_group == nil then
    icon = ""
    icon_highlight_group = "DevIconDefault"
  end

  -- Set colors.
  local highlight_color = modules.utils.extract_highlight_colors(icon_highlight_group, "fg")
  if highlight_color then
    local default_highlight = self:get_default_hl()
    local icon_highlight = Icon_hl_cache[highlight_color]
    if not icon_highlight or not modules.highlight.highlight_exists(icon_highlight.name .. "_normal") then
      icon_highlight = self:create_hl({ fg = highlight_color }, icon_highlight_group)
      Icon_hl_cache[highlight_color] = icon_highlight
    end
    icon = self:format_hl(icon_highlight) .. icon .. default_highlight
  end

  -- Return the formatted string.
  return icon
end

-- Return the current buffer's filename with the filetype icon.
function M:get_current_filename_with_icon()
  local suffix = " "

  -- Get icon and filename.
  local icon = M.get_current_filetype_icon(self)
  local f_name = get_current_filename()

  -- Add readonly icon.
  local readonly = vim.api.nvim_buf_get_option(0, "readonly")
  local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
  local nofile = get_current_buftype() == "nofile"
  if readonly or nofile or not modifiable then
    suffix = " "
  end

  -- Return the formatted string.
  return icon .. " " .. f_name .. suffix
end

-- Get the lsp of the current buffer, when using native lsp.
local function get_native_lsp()
  local buf_ft = get_current_filetype()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return "None"
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return "None"
end

-- check if value in table
local function contains(t, value)
  for _, v in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

local function get_lsps()
  local buf_ft = vim.bo.filetype
  local ui_filetypes = {
    "help",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "TelescopePrompt",
    "lspinfo",
    "lsp-installer",
    "",
  }

  if contains(ui_filetypes, buf_ft) then
    if M.language_servers == nil then
      return ""
    else
      return M.language_servers
    end
  end

  local clients = vim.lsp.buf_get_clients()
  local client_names = {}
  local copilot_active = false

  -- add client
  for _, client in pairs(clients) do
    if client.name ~= "copilot" and client.name ~= "null-ls" then
      table.insert(client_names, client.name)
    end
    if client.name == "copilot" then
      copilot_active = true
    end
  end

  -- add formatter
  local s = require "null-ls.sources"
  local available_sources = s.get_available(buf_ft)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end

  local formatter = registered["NULL_LS_FORMATTING"]
  local linter = registered["NULL_LS_DIAGNOSTICS"]
  if formatter ~= nil then
    vim.list_extend(client_names, formatter)
  end
  if linter ~= nil then
    vim.list_extend(client_names, linter)
  end

  -- join client names with commas
  local client_names_str = table.concat(client_names, ", ")

  -- check client_names_str if empty
  local language_servers = ""
  local client_names_str_len = #client_names_str
  if client_names_str_len ~= 0 then
    language_servers = client_names_str
  end
  if copilot_active then
    language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
  end

  if client_names_str_len == 0 and not copilot_active then
    return ""
  else
    M.language_servers = language_servers
    return language_servers:gsub(", anonymous source", "")
  end
end

-- Display the difference in commits between local and head.
local Job = require "plenary.job"
local function get_git_compare()
  -- Get the path of the current directory.
  local curr_dir = vim.api.nvim_buf_get_name(0):match("(.*" .. "/" .. ")")

  -- Run job to get git.
  local result = Job:new({
        command = "git",
        cwd = curr_dir,
        args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
      })
      :sync(100)[1]

  -- Process the result.
  if type(result) ~= "string" then
    return ""
  end
  local ok, ahead, behind = pcall(string.match, result, "(%d+)%s*(%d+)")
  if not ok then
    return ""
  end

  -- No file, so no git.
  if get_current_buftype() == "nofile" then
    return ""
  end

  -- Format for lualine.
  return " " .. behind .. "  " .. ahead
end

-- Get Codeium status
local function get_codeium_status()
  return "%3{codeium#GetStatusString()}"
end

-- Required to properly set the colors.

require("lualine").setup {
  sections = {
    lualine_a = {
      {
        "mode",
        icon = { " " },
      },
    },
    lualine_b = {
      {
        M.get_current_filename_with_icon,
      },
    },
    lualine_c = {
      {
        "branch",
        icon = {
          "",
          -- color = { fg = c.orange.bright, gui = 'bold' },
        },
        separator = " ",
      },
      {
        get_git_compare,
        separator = " ",
        icon = {
          " ",
          -- color = { fg = c.orange.bright, gui = 'bold' },
        },
      },
      {
        "diff",
        colored = true,
        source = diff_source,
        symbols = {
          -- added = ' ',
          -- modified = ' ',
          -- removed = ' ',
          added = " ",
          modified = " ",
          removed = " ",
        },
        diff_color = {
          -- added = { fg = c.gray4, gui = 'bold' },
          -- modified = { fg = c.gray4, gui = 'bold' },
          -- removed = { fg = c.gray4, gui = 'bold' },
        },
        -- icon = {
        -- ' ',
        -- color = { fg = c.orange.base },
        -- }
      },
    },
    lualine_x = {
      {
        get_codeium_status,
        icon = {
          "  ",
          align = "left",
          color = {
            -- fg = c.orange.bright,
            gui = "bold",
          },
        },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        separator = "",
        symbols = {
          -- error = ' ',
          -- warn = ' ',
          -- info = ' ',
          -- hint = ' ',
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
          other = "󰠠 ",
        },
        diagnostics_color = {
          -- error = { fg = c.error, gui = 'bold' },
          -- warn = { fg = c.warn, gui = 'bold' },
          -- info = { fg = c.info, gui = 'bold' },
          -- hint = { fg = c.hint, gui = 'bold' },
        },
        colored = true,
      },
    },
    lualine_y = {
      {
        get_lsps,
        icon = {
          "  ",
          align = "left",
          color = {
            -- fg = c.orange.bright,
            gui = "bold",
          },
        },
      },
    },
    lualine_z = {
      {
        "location",
        icon = {
          "",
          align = "left",
          -- color = { fg = c.black },
        },
      },
      {
        "progress",
        icon = {
          "",
          align = "left",
          -- color = { fg = c.black },
        },
        separator = { right = "█", left = { "" } },
      },
    },
  },
  options = {
    disabled_filetypes = { "dashboard" },
    globalstatus = true,
    section_separators = { left = " ", right = " " },
    component_separators = { left = "", right = "" },
    -- theme = 'nordic',
  },
  extensions = {
    "toggleterm",
    "nvim-tree",
  },
}
