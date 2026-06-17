-- avante.nvim recommended
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

local render_md_ft = { "markdown", "Avante", "codecompanion", "mcphub", "AgenticChat" }

local copilot_model = "gpt-5-mini" -- Set your preferred model here
local copilot_mini_model = "gpt-5-mini" -- Set your preferred model here

---@type LazySpec
return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
    config = function()
      local neocodeium = require "neocodeium"
      neocodeium.setup {
        enabled = true,
        debounce = true,
        filetypes = {
          yaml = true,
          markdown = true,
          gitcommit = true,
          gitrebase = true,
          ["dap-repl"] = false,
          ["grug-far"] = false,
          ["grug-far-history"] = false,
          ["grug-far-help"] = false,
        },
      }
      -- keymaps: match old copilot.lua binds
      vim.keymap.set("i", "<M-o>", neocodeium.accept)
      vim.keymap.set("i", "<M-O>", neocodeium.accept_line)
      vim.keymap.set("i", "<M-w>", neocodeium.accept_word)
      vim.keymap.set("i", "<M-]>", function()
        neocodeium.cycle(1)
      end)
      vim.keymap.set("i", "<M-[>", function()
        neocodeium.cycle(-1)
      end)
      vim.keymap.set("i", "<M-c>", neocodeium.clear)

      -- set highlight group for suggestion
      local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
      vim.api.nvim_set_hl(0, "NeoCodeiumSuggestion", { italic = true, fg = comment_hl.fg })
      vim.api.nvim_set_hl(0, "NeoCodeiumLabel", { italic = true, fg = comment_hl.fg })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      file_types = render_md_ft,
    },
    ft = render_md_ft,
    config = function()
      vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = "#50FA7B", bold = true, underline = true })
    end,
  },
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      jump = {
        jumplist = false, -- add an entry to the jumplist
      },
      nes = {
        enabled = false,
      },
      cli = {
        mux = {
          enabled = false,
        },
        tools = {
          claude = { cmd = { "claude", "--dangerously-skip-permissions" } },
          crush = { cmd = { "crush", "-y" } },
          gemini = { cmd = { "gemini", "-y" } },
          goose = { cmd = { "goose" } },
          kimi = { cmd = { "kimi", "-y" } },
          yomi = { cmd = { "yomi", "-y" } },
        },
        win = {
          keys = {
            prompt = false,
          },
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<M-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },

      {
        "<leader>at",
        function()
          require("sidekick.cli").send { msg = "{this}" }
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send { msg = "{file}" }
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send { msg = "{selection}" }
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}
