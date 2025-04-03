---@type LazySpec
return {
  {
    "ellisonleao/glow.nvim",
    ft = "markdown",
    config = true,
  },
  {
    "2kabhishek/nerdy.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup {
        -- options, see Configuration section below
        -- there are no required options atm
        -- engine = 'ripgrep' is default, but 'astgrep' can be specified
      }
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- 自定义插件
  {
    dir = "~/.config/nvim/lua/custom/bufferjump",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      {
        "B",
        function()
          require("custom.bufferjump").bufferjump()
        end,
        mode = "n",
        desc = "Buffer Jump",
      },
    },
  },
  {
    dir = "~/.config/nvim/lua/custom/betternoti",
    dependencies = { "rcarriga/nvim-notify" },
    event = "VeryLazy",
    config = function()
      local bt = require "custom.betternoti"
      bt.setup { blacklist = { "textDocument/" } }
      vim.notify = bt.notify
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      -- dashboard = { enabled = true, },
      -- terminal = { enabled = true },
      -- notifier = { enabled = true, timeout = 5000 }, -- already have nvim-notify
      quickfile = { enabled = true },
      -- scroll = { enabled = true },
      -- input = { enabled = true }, -- already have dressing.nvim
      lazygit = { enabled = true },
      scope = { enabled = true },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- stylua: ignore start
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
      -- stylua: ignore end
    },
    init = function()
      -- LSP-integrated file renaming with support for plugins
      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })
    end,
  },
}
