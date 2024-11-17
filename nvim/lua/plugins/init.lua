local plugin_groups = {
  require "plugins.lang",
  require "plugins.ai",
  require "plugins.dap",
  require "plugins.git",
  require "plugins.tool",
  require "plugins.editor",
}

---@type LazySpec
local M = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  }, -- format & linting
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = { enable = true },
      notify = { threshold = vim.log.levels.WARN },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
}

for _, g in ipairs(plugin_groups) do
  M = vim.list_extend(M, g)
end

return M
