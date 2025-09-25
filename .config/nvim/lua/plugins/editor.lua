local ft_3rd_party = { "alpha", "dashboard", "fugitive", "grug-far", "grug-far-help", "grug-far-history", "NvimTree" }

local function is_3rd_party_ft(ft)
  for _, v in ipairs(ft_3rd_party) do
    if ft == v then
      return true
    end
  end
  return false
end

---@type LazySpec
return {
  -- {{{ cmp
  {
    import = "nvchad.blink.lazyspec",
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
        },
        -- add vim-dadbod-completion to your completion providers
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
  },
  --- }}}
  {
    "neovim/nvim-lspconfig",
    lazy = false,
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
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>P", "<cmd>Trouble diagnostics toggle<cr>", desc = "Problems (Diagnostics)" },
    },
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "b0o/incline.nvim",
    enabled = false,
    config = function()
      local helpers = require "incline.helpers"
      local devicons = require "nvim-web-devicons"
      require("incline").setup {
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      }
    end,
    event = "VeryLazy",
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufRead",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      icons = {
        kinds = {
          dir_icon = function()
            return ""
          end,
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup {}
    end,
  },
  {
    "haringsrob/nvim_context_vt",
    event = "BufRead",
    config = function()
      require("nvim_context_vt").setup {
        prefix = "➜",
        min_rows = 20,
        disable_virtual_lines = true,
      }
    end,
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      -- require("leap").add_default_mappings()
      -- vim.cmd [[nnoremap gs <Plug>(leap-from-window)]]
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) -- or some grey
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
    end,
  },
  {
    "ggandor/flit.nvim",
    event = "VeryLazy",
    config = function()
      require("flit").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "BufRead",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        auto_enabled = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 or fsize == 0 then
              -- skip file size greater than 100k
              ret = false
            elseif bufname:match "^fugitive://" then
              -- skip fugitive buffer
              ret = false
            else
              ret = vim.fn.isdirectory(vim.fs.dirname(bufname))
            end
            return ret
          end,
        },
      }
    end,
  },
  {
    "editorconfig/editorconfig-vim",
    event = "BufRead",
    config = function()
      vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*", "term://*" }
    end,
  },
  {
    "chentoast/marks.nvim", -- display marks sign
    event = "BufRead",
    config = function()
      require("marks").setup {
        default_mappings = false,
      }
    end,
  },
  {
    "tummetott/unimpaired.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here if you wish to override the default settings
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "preservim/vim-markdown",
    dependencies = "godlygeek/tabular",
    ft = "markdown",
  },
  {
    "godlygeek/tabular",
    ft = "markdown",
  },
  {
    "wellle/targets.vim",
    event = "BufRead",
  },
  {
    "folke/which-key.nvim",
    enabled = true,
    event = "VeryLazy",
    -- keys = { "<leader>", '"', "'", "`", "z", "g" },
    opts = {
      plugins = {
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
      },
    },
  },
  {
    "smjonas/live-command.nvim",
    cmd = "Norm",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = {
            cmd = "norm",
          },
        },
      }
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      open_mapping = [[<c-\>]],
      -- start_in_insert = false,
      -- shade_terminals = true,
      size = 20,
      auto_scroll = false,
      float_opts = {
        border = "curved",
      },
      winbar = {
        -- enabled = true,
      },
    },
    cmd = { "ToggleTerm" },
    init = function()
      local function set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = set_terminal_keymaps,
      })
    end,
  },
  { "AndrewRadev/bufferize.vim", cmd = "Bufferize" },
  { "tpope/vim-repeat", event = "BufRead" },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    config = true,
  },
  {
    "gbprod/yanky.nvim",
    event = "BufRead",
    config = function()
      require("yanky").setup {
        highlight = { on_put = false, on_yank = false },
      }
      require("telescope").load_extension "yank_history"
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    event = "BufRead",
    keys = {
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "n",
        desc = "Refactor",
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.printf { below = true }
        end,
        mode = "n",
        desc = "Refactor print",
      },
      {
        "<leader>rv",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = "n",
        desc = "Refactor print var",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup {}
        end,
        mode = "n",
        desc = "Refactor cleanup",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("refactoring").setup()
    end,
  },
  {
    "olimorris/persisted.nvim",
    event = "BufRead",
    cmd = { "SessionSave" },
    config = function()
      require("persisted").setup {
        follow_cwd = true,
        should_autosave = function()
          local ft = vim.bo.filetype
          return not is_3rd_party_ft(ft)
        end,
      }
      require("telescope").load_extension "persisted"
    end,
  },
  {
    "sphamba/smear-cursor.nvim", -- cursor like neovide
    opts = {},
    enabled = false and not vim.g.neovide, -- kitty have this feature
    event = "VeryLazy",
  },
  {
    "j-hui/fidget.nvim", -- lsp progress at bottom right
    opts = {
      -- options
    },
    event = "BufRead",
  },
  {
    "jvgrootveld/telescope-zoxide",
    keys = {
      {
        "<leader>cd",
        function()
          require("telescope").extensions.zoxide.list()
        end,
        mode = "n",
        desc = "Autojump",
      },
    },
    config = function()
      require("telescope").load_extension "zoxide"
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup {
        hide_if_all_visible = true,
        marks = {
          Cursor = { text = "🐭" },
        },
      }
    end,
  },
  {
    "chrisgrieser/nvim-origami",
    event = "BufRead",
    opts = {
      foldtext = {
        lineCount = {
          template = "    •••••••  %s lines  •••••••  ",
          hlgroup = "Folded",
        },
      },
    }, -- needed even when using default config
    config = function(_, opts)
      require("origami").setup(opts)
    end,
  },
  { "nvzone/volt", lazy = true },
  { "nvzone/menu", lazy = true },
  {
    "folke/which-key.nvim",
    opts = { preset = "helix" },
  },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disable_mouse = false,
      restricted_keys = {
        l = false,
        h = false,
      },
      disabled_keys = {
        ["<Up>"] = false,
        ["<Down>"] = false,
        ["<Left>"] = false,
        ["<Right>"] = false,
      },
    },
  },
  {
    "echasnovski/mini.diff",
    event = "VeryLazy",
    config = function()
      require("mini.diff").setup()
    end,
  },

  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    enabled = os.getenv "SSH_CONNECTION" ~= nil,
    config = function()
      vim.api.nvim_create_augroup("Yank", {})
      vim.api.nvim_create_autocmd("TextYankPost", {
        group = "Yank",
        callback = function()
          if vim.v.event.operator == "y" then
            -- Only copy to OSC52 register if the yank is not explicitly named
            require("osc52").copy_register '"'
          end
        end,
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup {
        winopts = {
          border = "rounded",
          preview = {
            border = "rounded",
            scrollbar = false,
          },
        },
        hls = {
          border = "TelescopeBorder", -- or "FloatBorder"
          preview_border = "TelescopeBorder",
          title = "TelescopePromptTitle",
          preview_title = "TelescopePreviewTitle",
        },
      }
    end,
  },

  -- 自定义插件
  {
    dir = "~/.config/nvim/lua/custom/betternoti",
    dependencies = { "rcarriga/nvim-notify" },
    event = "VeryLazy",
    config = function()
      local bt = require "custom.betternoti"
      bt.setup {
        blacklist = { "textDocument/" },
        top_down = false,
        max_width = 60,
      }
      vim.notify = bt.notify
    end,
  },
}
