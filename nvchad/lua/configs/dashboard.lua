local function load_session_for_cwd()
  require("persisted").load()
  if not vim.g.persisted_exists then
    vim.notify("No session found", vim.log.levels.INFO, { title = "Session" })
    return false
  else
    vim.notify("Session loaded", vim.log.levels.INFO, { title = "Session" })
    return true
  end
end

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
        if not load_session_for_cwd() then
          require("telescope.builtin").find_files { cwd = path }
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
        desc = " Load Session",
        group = "Number",
        action = load_session_for_cwd,
        key = "l",
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
