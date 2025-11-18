---@type LazySpec
return {
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
      { "tpope/vim-dadbod", cmd = { "DB" } },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } }, -- Optional
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
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      image = { enabled = true },
      -- dashboard = { enabled = true, },
      -- terminal = { enabled = true },
      -- notifier = { enabled = true, timeout = 5000 }, -- already have nvim-notify
      quickfile = { enabled = true },
      -- scroll = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      scope = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
      picker = {
        prompt = "   ",
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.8,
              min_width = 120,
              height = 0.8,
              {
                box = "vertical",
                border = "solid",
                title = "{title} {live} {flags}",
                { win = "input", height = 2, border = "none" },
                { win = "list", border = "none" },
              },
              { win = "preview", title = "{preview}", border = "solid", width = 0.5 },
            },
          },
        },
      },
      styles = {
        input = {
          backdrop = true,
          row = -3,
          width = 45,
          relative = "cursor",
        },
      },
    },
    keys = {
      -- stylua: ignore start
      -- top
      -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "B", function() Snacks.picker.buffers({ layout = { preset = "ivy" } }) end, desc = "Buffers" },

      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },

      -- lsp
      { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      { "<leader>ld", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>lD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },

       -- Other
      -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<C-w>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
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
      -- Setup some globals for debugging (lazy-loaded)
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.line_number():map "<leader>ul"
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map "<leader>uc"
          Snacks.toggle.treesitter():map "<leader>uT"
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
          Snacks.toggle.inlay_hints():map "<leader>uh"
          Snacks.toggle.indent():map "<leader>ug"
          Snacks.toggle.dim():map "<leader>uD"

          -- Set some highlights
          vim.api.nvim_set_hl(0, "FloatTitle", { link = "TelescopePromptTitle" })
          vim.api.nvim_set_hl(0, "SnacksPickerTitle", { link = "TelescopePromptTitle" })
          vim.api.nvim_set_hl(0, "SnacksPickerPreviewTitle", { link = "TelescopePreviewTitle" })
          vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { link = "TelescopePromptPrefix" })
          vim.api.nvim_set_hl(0, "SnacksPickerInput", { link = "TelescopePromptNormal" })

          -- vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "TelescopeBorder" })
          vim.api.nvim_set_hl(0, "SnacksInputTitle", { link = "TelescopePromptTitle" })
          vim.api.nvim_set_hl(0, "SnacksInputBorder", { link = "TelescopeBorder" })
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },
  {
    "skywind3000/asyncrun.vim",
    cmd = "AsyncRun",
    config = function()
      vim.g.asyncrun_open = 10
    end,
  },
}
