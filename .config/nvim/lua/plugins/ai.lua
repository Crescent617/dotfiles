-- avante.nvim recommended
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

local render_md_ft = { "markdown", "Avante", "codecompanion", "mcphub" }

-- gpt-3.5-turbo gpt-4o-mini gpt-4 gpt-4o o1 o3-mini o3-mini-paygo
-- claude-3.5-sonnet claude-3.7-sonnet claude-3.7-sonnet-thought claude-sonnet-4
-- gemini-2.5-pro o4-mini gpt-4.1
local copilot_model = "gpt-4.1" -- Set your preferred model here

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-p>",
            accept_line = "<M-o>",
            accept_word = "<M-w>",
          },
        },
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
        -- copilot_model = "gpt-4o-copilot",
      }
      -- set highlight group for copilot
      local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
      vim.api.nvim_set_hl(0, "CopilotSuggestion", { italic = true, fg = comment_hl.fg })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      require("codecompanion").setup {
        opts = {
          language = "Chinese",
        },
        strategies = {
          chat = {
            adapter = "copilot",
            roles = {
              -- llm = function(adapter)
              --   return "  CodeCompanion (" .. adapter.model.name .. ")"
              -- end,
              user = "  Me",
            },
          },
          inline = { adapter = "copilot" },
          cmd = { adapter = "copilot" },
        },
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {},
              })
            end,
          },
          http = {
            copilot = function()
              return require("codecompanion.adapters").extend("copilot", {
                -- schema = { model = { default = copilot_model } },
              })
            end,
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },
          history = {
            enabled = true,
            opts = {
              auto_generate_title = false,
            },
          },
        },
      }
    end,
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "CodeCompanion" },
      { "<leader>ai", "<cmd>CodeCompanionChat<cr>", mode = "x", desc = "CodeCompanion" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
    },
    init = function()
      require("configs.codecompanion_progress").init {}
      require("configs.codecompanion_spinner"):init()
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    event = "VeryLazy",
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub", -- lazy load by default
    -- build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function()
      require("mcphub").setup {
        use_bundled_binary = true, -- Set to true if you want to use the bundled mcp-hub binary
        auto_approve = true,
        extensions = {
          codecompanion = {
            -- Show the mcp tool result in the chat buffer
            show_result_in_chat = true,
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },
      }
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
}
