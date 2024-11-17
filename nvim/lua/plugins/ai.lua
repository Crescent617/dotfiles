-- avante.nvim recommended
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

---@type LazySpec
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",
      copilot = {
        model = "claude-3.5-sonnet",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante", "codecompanion" },
        },
        ft = { "markdown", "Avante", "codecompanion" },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "BufRead",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- debug = true, -- Enable debugging
      -- window = {
      --   layout = "float",
      --   width = 0.75,
      --   height = 0.75,
      -- },
    },
  },

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
            accept = "<M-o>",
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
      }
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    config = function()
      require("codecompanion").setup {
        opts = {
          language = "chinese",
        },
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
          cmd = {
            adapter = "copilot",
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.5-sonnet",
                },
              },
            })
          end,
        },
      }
    end,
    keys = {
      {
        "<leader>ai",
        function()
          vim.cmd "CodeCompanionChat"
        end,
        mode = "n",
        desc = "CopilotChat",
      },
      {
        "<leader>ai",
        function()
          vim.cmd "CodeCompanion"
        end,
        mode = "v",
        desc = "CopilotChat",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      -- lua/plugins/codecompanion/fidget-spinner.lua

      local progress = require "fidget.progress"

      local M = {}

      function M:init()
        local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = "CodeCompanionRequestStarted",
          group = group,
          callback = function(request)
            local handle = M:create_progress_handle(request)
            M:store_progress_handle(request.data.id, handle)
          end,
        })

        vim.api.nvim_create_autocmd({ "User" }, {
          pattern = "CodeCompanionRequestFinished",
          group = group,
          callback = function(request)
            local handle = M:pop_progress_handle(request.data.id)
            if handle then
              M:report_exit_status(handle, request)
              handle:finish()
            end
          end,
        })
      end

      M.handles = {}

      function M:store_progress_handle(id, handle)
        M.handles[id] = handle
      end

      function M:pop_progress_handle(id)
        local handle = M.handles[id]
        M.handles[id] = nil
        return handle
      end

      function M:create_progress_handle(request)
        return progress.handle.create {
          title = " Requesting assistance (" .. request.data.strategy .. ")",
          message = "In progress...",
          lsp_client = {
            name = M:llm_role_title(request.data.adapter),
          },
        }
      end

      function M:llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
          table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
      end

      function M:report_exit_status(handle, request)
        if request.data.status == "success" then
          handle.message = "Completed"
        elseif request.data.status == "error" then
          handle.message = " Error"
        else
          handle.message = "󰜺 Cancelled"
        end
      end

      M:init()
    end,
  },
}
