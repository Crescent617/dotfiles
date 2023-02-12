local M = {
  -- utils
  ["folke/trouble.nvim"] = {
    event = "BufRead",
  },
  ["kosayoda/nvim-lightbulb"] = {
    event = "BufRead",
    config = function()
      vim.cmd [[autocmd CursorHold * lua require'nvim-lightbulb'.update_lightbulb()]]
    end,
  },
  ["andymass/vim-matchup"] = {
    setup = function()
      -- may set any options here
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- lsp
  ["neovim/nvim-lspconfig"] = {
    after = "neodev.nvim",
    config = function()
      require "custom.plugins.lspconfig"
    end,
  },
  -- format & linting
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.null-ls"
    end,
  },
  ["windwp/nvim-spectre"] = {
    module = "spectre",
    config = function()
      require("spectre").setup { mapping = { ["send_to_qf"] = { map = "<C-q>" } } }
    end,
  },
  ["f-person/git-blame.nvim"] = { event = "BufRead" },
  ["folke/todo-comments.nvim"] = {
    requires = "nvim-lua/plenary.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup {}
    end,
  },
  ["nvim-tree/nvim-tree.lua"] = {
    override_options = {
      git = {
        enable = true,
      },
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
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = {
      ensure_installed = {
        "vim",
        "html",
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
      },
    },
  },
  ["rhysd/conflict-marker.vim"] = {
    event = "BufRead",
  },
  ["goolord/alpha-nvim"] = {
    disable = false,
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },
  ["ggandor/lightspeed.nvim"] = {
    config = function()
      require("lightspeed").setup {
        ignore_case = true,
      }
    end,
  },
  ["tpope/vim-surround"] = { event = "BufRead" },
  ["simrat39/rust-tools.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("rust-tools").setup {
        server = {
          on_attach = require("plugins.configs.lspconfig").on_attach,
          settings = {
            ["rust-analyzer"] = {
              inlayHints = { locationLinks = false },
            },
          },
        },
      }
    end,
  },
  ["sindrets/diffview.nvim"] = { requires = "nvim-lua/plenary.nvim" },
  ["tpope/vim-fugitive"] = { event = "BufRead" },
  ["NTBBloodbath/rest.nvim"] = {
    ft = "http",
    config = function()
      require("rest-nvim").setup {}
      vim.cmd [[
         nnoremap <leader>rr <Plug>RestNvim
         nnoremap <leader>rp <Plug>RestNvimPreview
         nnoremap <leader>rl <Plug>RestNvimLast
      ]]
    end,
  },
  ["stevearc/dressing.nvim"] = {
    event = "BufRead",
    config = function()
      require("dressing").setup {}
    end,
  },
  ["Shatur/neovim-session-manager"] = {
    disable = true,
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("session_manager").setup {
        autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
      }
    end,
  },
  ["kevinhwang91/nvim-bqf"] = {
    ft = "qf",
    config = function()
      require("bqf").setup {
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
          show_title = false,
          should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
              -- skip file size greater than 100k
              ret = false
            elseif bufname:match "^fugitive://" then
              -- skip fugitive buffer
              ret = false
            end
            return ret
          end,
        },
        -- make `drop` and `tab drop` to become preferred
        -- func_map = {
        --   drop = 'o',
        --   openc = 'O',
        --   split = '<C-s>',
        --   tabdrop = '<C-t>',
        --   tabc = '',
        --   ptogglemode = 'z,',
        -- },
        -- filter = {
        --   fzf = {
        --     action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop' },
        --     extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' }
        --   }
        -- }
      }
    end,
  },
  ["editorconfig/editorconfig-vim"] = {
    event = "BufRead",
    config = function()
      vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*", "term://*" }
    end,
  },
  ["simrat39/symbols-outline.nvim"] = {
    config = function()
      require("symbols-outline").setup()
    end,
  },
  ["toppair/reach.nvim"] = {
    event = "BufRead",
    config = function()
      -- default config
      require("reach").setup {}
      vim.cmd [[
        hi! link ReachHandleDelete DiffRemoved
      ]]
    end,
  },
  ["simnalamburt/vim-mundo"] = { event = "BufRead" },
  ["ellisonleao/glow.nvim"] = {
    ft = "markdown",
    config = function()
      require("glow").setup {
        width = 120,
      }
    end,
  },
  ["chentoast/marks.nvim"] = {
    event = "BufRead",
    config = function()
      require("marks").setup {
        default_mappings = false,
      }
    end,
  },
  ["AndrewRadev/bufferize.vim"] = {},
  ["haringsrob/nvim_context_vt"] = {
    event = "BufRead",
    config = function()
      require("nvim_context_vt").setup {
        prefix = "➜",
        min_rows = 20,
        disable_virtual_lines = true,
      }
    end,
  },
  ["ray-x/go.nvim"] = {
    after = "nvim-lspconfig",
    ft = { "go" },
    requires = { "ray-x/guihua.lua" },
    config = function()
      require("go").setup()
    end,
  },
  -- ["nvim-telescope/telescope.nvim"] = { module = "telescope" },
  ["mfussenegger/nvim-dap"] = {
    config = function()
      require "custom.plugins.dap"
    end,
  },
  ["rcarriga/nvim-dap-ui"] = {
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup {}
    end,
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  ["danymat/neogen"] = {
    event = "BufRead",
    config = function()
      require("neogen").setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
  },
  ["padde/jump.vim"] = {
    config = function()
      vim.g.autojump_vim_command = "tcd"
    end,
  }, -- use for autojump
  ["tpope/vim-unimpaired"] = {
    event = "BufRead",
  },
  ["windwp/nvim-ts-autotag"] = {
    event = "BufRead",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  ["mickael-menu/zk-nvim"] = {
    config = function()
      require("zk").setup {
        picker = "telescope",
      }
    end,
  },
  ["preservim/vim-markdown"] = { requires = "godlygeek/tabular", ft = "markdown" },
  ["godlygeek/tabular"] = { ft = "markdown" },
  ["jbyuki/nabla.nvim"] = {
    ft = "markdown",
    config = function()
      vim.cmd "command! Nabla :lua require('nabla').popup()<CR>[]"
    end,
  },
  ["wellle/targets.vim"] = { event = "BufRead" },
  ["nvim-neotest/neotest"] = {
    event = "BufRead",
    requires = {
      "vim-test/vim-test",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-vim-test",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-go",
          require "neotest-plenary",
          require "neotest-vim-test" {
            ignore_file_types = { "go", "vim", "lua" },
          },
        },
      }
    end,
  },
  ["freitass/todo.txt-vim"] = { event = "BufRead" },
  ["sbdchd/neoformat"] = {
    event = "BufRead",
    config = function()
      vim.g.neoformat_go_gofmt = { exe = "gofmt", args = { "-s" } }
    end,
  },
  ["chrisbra/csv.vim"] = {
    ft = "csv",
    config = function()
      vim.g.no_csv_maps = 1
    end,
  },
  ["folke/which-key.nvim"] = {
    disable = false,
    override_options = {
      plugins = {
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
      },
    },
    config = function()
      require "plugins.configs.whichkey"
      local wk = require "which-key"
      wk.register({
        f = { name = "find" },
        t = { name = "test" },
        l = { name = "lsp" },
        g = { name = "git" },
        d = { name = "debug" },
      }, { prefix = "<leader>" }) --insert any whichkey opts here
    end,
  },
  ["rcarriga/nvim-notify"] = {
    -- disable = true,
    after = "nvim-lspconfig",
    config = function()
      local banned_words = { "textDocument/", "multiple different client offset_encodings detected" }
      local notify = require "notify"
      vim.notify = function(msg, ...)
        for _, banned in ipairs(banned_words) do
          if string.find(msg, banned) then
            return
          end
        end
        notify(msg, ...)
      end
    end,
  },
  ["nvim-treesitter/nvim-treesitter-context"] = {
    event = "BufRead",
    config = function()
      vim.cmd [[hi TreesitterContextBottom gui=underline guisp=Grey]]
      require("treesitter-context").setup {}
    end,
  },
  ["j-hui/fidget.nvim"] = {
    disable = true,
    config = function()
      require("fidget").setup {}
    end,
  },
  ["smjonas/live-command.nvim"] = {
    event = "BufRead",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },
  ["wbthomason/packer.nvim"] = {
    override_options = {
      max_jobs = 20,
    },
  },
  ["NvChad/nvterm"] = {
    disable = true,
    override_options = {
      terminals = {
        type_opts = {
          float = {
            relative = "editor",
            row = 0.15,
            col = 0.15,
            width = 0.7,
            height = 0.7,
            border = "single",
          },
        },
      },
    },
  },
  ["folke/neodev.nvim"] = {
    ft = "lua",
    config = function()
      require("neodev").setup {}
    end,
  },
  ["rafcamlet/nvim-luapad"] = { requires = "antoinemadec/FixCursorHold.nvim" },
  ["michaelb/sniprun"] = {
    run = "bash ./install.sh",
    config = function()
      require("sniprun").setup {}
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    tag = "*",
    config = function()
      require("toggleterm").setup {
        open_mapping = [[<c-\>]],
        start_in_insert = false,
        shade_terminals = true,
        auto_scroll = false,
        float_opts = {
          border = "curved",
        },
      }
      vim.keymap.set("t", "jk", [[<C-\><C-n>]])
    end,
  },
  ["b0o/incline.nvim"] = {
    event = "BufRead",
    config = function()
      require("incline").setup()
    end,
  },
  ["hrsh7th/cmp-cmdline"] = {
    after = "nvim-cmp",
    config = function()
      local cmp = require "cmp"
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  ["iamcco/markdown-preview.nvim"] = {
    ft = "markdown",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}

return M
