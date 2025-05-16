local util = require "configs.util"
local load_session_for_cwd = util.load_session_for_cwd

return {
  theme = "hyper",
  -- shortcut_type = "number",
  config = {
    week_header = {
      enable = true,
    },
    project = {
      enable = true,
      action = function(path)
        if not load_session_for_cwd() then
          require("telescope.builtin").find_files { cwd = path }
        end
      end,
    },
    mru = { cwd_only = true, limit = 17 },
    shortcut = {
      {
        desc = " New File",
        group = "DiagnosticWarn",
        action = "enew",
        key = "e",
      },
      {
        desc = " Files",
        group = "DiagnosticInfo",
        action = "Telescope find_files",
        key = "f",
      },
      {
        desc = " Old Files",
        group = "@attribute",
        action = function(path)
          require("telescope.builtin").oldfiles { cwd = path, cwd_only = true }
        end,
        key = "o",
      },
      {
        desc = " Load Session",
        group = "DiagnosticSignOK",
        action = load_session_for_cwd,
        key = "l",
      },
      { desc = "󰚰 Update", group = "@property", action = "Lazy update", key = "u" },
      -- {
      --   desc = " Sessions",
      --   group = "DiagnosticInfo",
      --   action = "Telescope persisted",
      --   key = "s",
      -- },
      {
        desc = "󰈆 Quit",
        key = "q",
        action = "qall",
        group = "DiagnosticError",
      },
    },
    footer = {
      "",
      "🐱 Take it easy!",
    },
  },
}
