-- avante.nvim recommended
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

local render_md_ft = { "markdown", "Avante", "codecompanion", "mcphub", "AgenticChat" }

local copilot_model = "gpt-5-mini" -- Set your preferred model here
local copilot_mini_model = "gpt-5-mini" -- Set your preferred model here

---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      -- "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
      -- init = function()
      --   vim.g.copilot_nes_debounce = 500
      -- end,
    },
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<M-o>",
            accept_line = "<M-O>",
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
    cmd = { "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd", "CodeCompanion" },
    config = function()
      require("codecompanion").setup {
        opts = {
          language = "Chinese",
          -- log_level = "DEBUG",
        },
        interactions = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
          background = {
            adapter = {
              name = "copilot",
              model = copilot_mini_model,
            },
          },
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
                schema = { model = { default = copilot_model } },
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
      {
        "<leader>ai",
        "<cmd>CodeCompanionChat Toggle adapter=claude_code command=yolo<cr>",
        mode = { "n", "x", "i" },
        desc = "CodeCompanion Toggle",
      },
      {
        "<leader>ak",
        function()
          vim.ui.input({ prompt = "What kind of command to run? " }, function(input)
            if input then
              vim.cmd("CodeCompanionCmd " .. input)
            end
          end)
        end,
        mode = "n",
        desc = "CodeCompanionCmd",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      "ravitemer/mcphub.nvim",
    },
    init = function()
      require("configs.codecompanion_progress").init {}
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
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
