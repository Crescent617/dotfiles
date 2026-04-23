local frontend_formatter = { "prettierd", "prettier", stop_after_first = true }

---@type LazySpec
return {
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
        python = { "ruff_organize_imports", "ruff_format" },
        javascript = frontend_formatter,
        typescript = frontend_formatter,
        javascriptreact = frontend_formatter,
        typescriptreact = frontend_formatter,
        svelte = frontend_formatter,
        vue = frontend_formatter,
        go = { "goimports", "gofmt" },
        sql = { "pg_format", "sql_formatter", "sqlfluff", stop_after_first = true },
        json = frontend_formatter,
        proto = { "buf" },
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
    branch = "main",
    config = function()
      local chadrc = require "chadrc"
      local ensure_installed = chadrc.tree_sitter and chadrc.tree_sitter.ensure_installed or {}

      vim.api.nvim_create_user_command("TSInstallEnsure", function()
        local ts = require "nvim-treesitter"
        for _, lang in ipairs(ensure_installed) do
          vim.cmd("TSInstall " .. lang)
        end
        vim.notify("Triggered install for " .. #ensure_installed .. " parsers", vim.log.levels.INFO)
      end, { desc = "Install all parsers defined in chadrc tree_sitter.ensure_installed" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    config = function()
      require("treesitter-context").setup {
        separator = "·",
        max_lines = "10%",
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufRead",
    config = function()
      -- keymaps
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end)
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ "n", "x", "o" }, "]o", function()
        require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
      end)

      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end)

      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end)

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ "n", "x", "o" }, "]d", function()
        require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[d", function()
        require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
      end)
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
    version = "*", -- Recommended
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
            ["rust-analyzer"] = {
              -- cargo = { loadOutDirsFromCheck = true },
              -- check = { command = "clippy" },
              -- procMacro = { enable = false },
              -- diagnostics = { enable = true },
              -- completion = { postfix = { enable = false } },
              -- buildScripts = { enable = false }, -- 重点：关闭 build.rs 分析，加速
            },
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "lawrence-laz/neotest-zig",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-go",
      -- "nvim-neotest/neotest-vim-test",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-go",
          require "neotest-plenary",
          require "neotest-zig" { dap = { adapter = "lldb" } },
          require "rustaceanvim.neotest",
          -- require "neotest-vim-test",
        },
      }
    end,
  },
  {
    "b0o/schemastore.nvim",
  },
  {
    "qvalentin/helm-ls.nvim",
    ft = "helm",
    opts = {
      -- leave empty or see below
    },
  },
  {
    "vim-test/vim-test",
    event = "BufRead",
    config = function()
      vim.g["test#strategy"] = "toggleterm"
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufRead",
    config = function()
      require("lint").linters_by_ft = {
        -- zig = { "zlint" },
        proto = { "buf_lint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()

          -- You can call `try_lint` with a linter name or a list of names to always
          -- run specific linters, independent of the `linters_by_ft` configuration
          -- require("lint").try_lint "cspell"
        end,
      })
    end,
  },
}
