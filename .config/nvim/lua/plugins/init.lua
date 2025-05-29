local plugin_groups = {
  require "plugins.lang",
  require "plugins.ai",
  require "plugins.dap",
  require "plugins.git",
  require "plugins.tool",
  require "plugins.editor",
  require "plugins.note",
}

---@type LazySpec
local M = {
  {
    dir = "~/.config/nvim/lua/custom/theme",
    event = "VeryLazy",
    config = function()
      require("custom.theme").setup()
    end,
  },
}

for _, g in ipairs(plugin_groups) do
  M = vim.list_extend(M, g)
end

return M
