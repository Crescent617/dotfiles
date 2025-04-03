local frontend_formatter = { "prettierd", "prettier", stop_after_first = true }

---@type LazySpec
return {
  { "folke/trouble.nvim", cmd = "Trouble", opts = {} },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>fm",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = frontend_formatter,
        typescript = frontend_formatter,
        javascriptreact = frontend_formatter,
        typescriptreact = frontend_formatter,
        go = { "goimports", "gofumpt" },
        sql = { "sql-formatter" },
      },
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "html",
        "lua",
        "css",
        "javascript",
        "typescript",
        "json",
        "toml",
        "yaml",
        "markdown",
        "c",
        "rust",
        "go",
        "python",
        "bash",
        "tsx",
        "http",
        "query",
      },
      highlight = {
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    config = function()
      require("treesitter-context").setup {
        separator = "·",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufRead",
    config = function()
      require("nvim-treesitter.configs").setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              --
              -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
              ["]o"] = "@loop.*",
              -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
              --
              -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
              -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
              ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "BufRead",
    config = function()
      local null_ls = require "null-ls"
      local b = null_ls.builtins

      local sources = {
        b.diagnostics.codespell.with {
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.INFO
          end,
          disabled_filetypes = { "NvimTree", "csv" },
          args = { "-L", "crate,ans,ratatui", "-" },
        },
      }
      null_ls.setup {
        -- debug = true,
        sources = sources,
      }
    end,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      require "configs.symbol-usage"
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    event = "BufRead",
    config = function()
      require("symbols-outline").setup()
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    ft = { "go", "gomod" },
  },
  {
    "zk-org/zk-nvim",
    event = "VeryLazy",
    config = function()
      require("zk").setup {
        picker = "telescope",
      }

      local function new_note()
        vim.ui.input({
          prompt = "Title",
        }, function(title)
          if title then
            require("zk.commands").get "ZkNew" { title = title }
          end
        end)
      end

      vim.keymap.set("n", "<leader>nn", new_note, { desc = "New Note" })
      vim.api.nvim_set_keymap("n", "<leader>nl", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Note List" })
    end,
  },

  {
    "mechatroner/rainbow_csv",
    ft = "csv",
    config = function()
      vim.g.rbql_with_headers = 1
    end,
  },
  {
    "Saecki/crates.nvim",
    version = "*",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      }
    end,
  },
  {
    "dnlhc/glance.nvim",
    event = "BufRead",
    config = function()
      local glance = require "glance"
      local actions = glance.actions
      glance.setup {
        mappings = {
          list = {
            ["<C-h>"] = actions.enter_win "preview", -- Focus preview window
          },
          preview = {
            ["<C-l>"] = actions.enter_win "list", -- Focus list window
          },
        },
      }
      -- Lua
      vim.keymap.set("n", "gpd", "<CMD>Glance definitions<CR>")
      vim.keymap.set("n", "gpr", "<CMD>Glance references<CR>")
      vim.keymap.set("n", "gpt", "<CMD>Glance type_definitions<CR>")
      vim.keymap.set("n", "gpi", "<CMD>Glance implementations<CR>")
    end,
  },
  { "NoahTheDuke/vim-just", ft = "just" },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = "rust",
    config = function()
      local lspconfig = require "configs.lspconfig"
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = lspconfig.on_attach,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {},
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    event = "BufRead",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "vim-test/vim-test",
        config = function()
          vim.cmd 'let test#strategy ="neovim"'
        end,
      },
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-vim-test",
      -- "nvim-neotest/neotest-go",
      -- "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          -- require "neotest-rust",
          -- require "neotest-go",
          require "neotest-plenary",
          -- require "rustaceanvim.neotest",
          require "neotest-vim-test",
        },
      }
    end,
  },
}
