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
    event = "BufRead",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      -- configuration
      require("nvim-treesitter-textobjects").setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = false,
        },
      }

      -- keymaps
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
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
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {}
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
