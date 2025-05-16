local plugin_groups = {
  require "plugins.lang",
  require "plugins.ai",
  require "plugins.dap",
  require "plugins.git",
  require "plugins.tool",
  require "plugins.editor",
}

---@type LazySpec
local M = {}

for _, g in ipairs(plugin_groups) do
  M = vim.list_extend(M, g)
end

return M
