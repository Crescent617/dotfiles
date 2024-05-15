return {
  theme = "hyper",
  -- shortcut_type = "number",
  config = {
    week_header = {
      enable = true,
    },
    project = {
      limit = 10,
      action = function(path)
        local _ = require "persisted"
        vim.cmd "SessionLoad"
        if not vim.g.persisted_exists then
          require("telescope.builtin").find_files { cwd = path }
        else
          vim.notify(path, vim.log.levels.INFO, { title = "Project Loaded" })
        end
      end,
    },
    mru = { limit = 17 },
    shortcut = {
      {
        desc = " New File",
        group = "Include",
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
        group = "@keyword",
        action = function(path)
          require("telescope.builtin").oldfiles { cwd = path, cwd_only = true }
        end,
        key = "o",
      },
      {
        desc = " All Old Files",
        group = "Number",
        action = "Telescope oldfiles",
        key = "O",
      },
      { desc = "󰚰 Update", group = "@property", action = "Lazy update", key = "u" },
      {
        desc = "󰩈 Quit",
        key = "q",
        action = "qall",
      },
    },
    footer = {
      "",
      "🐱 Take it easy!",
    },
  },
}
