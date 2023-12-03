local M = {}

-- add this table only when you want to disable default keys
M.disabled = {
  n = {
    ["<C-q>"] = "",
    ["<C-s>"] = "",
    ["<S-b>"] = "",
    ["<leader>D"] = "",
    ["<leader>bc"] = "",
    ["<leader>f"] = "",
    ["<leader>h"] = "",
    ["<leader>ls"] = "",
    ["<leader>q"] = "",
    ["<leader>tn"] = "",
    ["<leader>tp"] = "",
    ["<leader>tt"] = "",
    ["<leader>v"] = "",
    ["<leader>wK"] = "",
    ["<leader>wa"] = "",
    ["<leader>wk"] = "",
    ["<leader>wl"] = "",
    ["<leader>wr"] = "",
    -- ["gx"] = "",
    ["gi"] = "",
    ["<Bslash>"] = "",
  },
  i = {
    ["<C-h>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
    ["<C-l>"] = "",
  },
}

M.general = {
  n = {
    ["<C-q>"] = { "<cmd>call QuickFixToggle()<CR>", "Toggle Quickfix" },
    ["<C-w>z"] = { "<cmd>resize | vertical resize<CR>", "Zoom in window" },
    ["<leader>q"] = { "<cmd>q<cr>", "quit" },
    ["<leader>w"] = { "<cmd>w<cr>", "save" },
    ["<leader>."] = { ":<Up><CR>", "last cmd" },
    ["<leader>;"] = { "<cmd>Alpha<CR>", "open dashboard" },
    ["<leader>S"] = { "<cmd>lua require('spectre').open()<CR>", "spectre" },
    ["<leader>tp"] = { "<cmd>TroubleToggle<CR>", "problems" },
    ["<leader>b"] = { "<cmd>b#<cr>", "last buffer" },
    -- ["gx"] = { "<cmd>silent !open <cfile><cr>", "open cursor file with system default" },
    ["<Esc>"] = { "<cmd>nohl<cr>", "nohl" },
  },
  v = {
    ["<leader>S"] = { "<cmd>lua require('spectre').open_visual()<CR>", "spectre" },
  },
}

M.neotest = {
  n = {
    ["<leader>tf"] = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', "Test File" },
    ["<leader>tn"] = { '<cmd>lua require("neotest").run.run()<cr>', "Test Nearest" },
    ["<leader>to"] = { '<cmd>lua require("neotest").output.open({ enter = true })<cr>', "Show Test Output" },
    ["<leader>ta"] = { '<cmd>lua require("neotest").run.attach()<cr>', "Attach Test" },
    ["<leader>ts"] = { '<cmd>lua require("neotest").run.stop()<cr>', "Stop Test" },
    ["<leader>tt"] = { '<cmd>lua require("neotest").summary.toggle()<cr>', "Toggle Test Outline" },
  },
}

M.debug = {
  n = {
    ["<leader>db"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    ["<leader>dS"] = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    ["<leader>dc"] = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    ["<leader>dC"] = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
    ["<leader>dd"] = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    ["<leader>dg"] = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    ["<leader>ds"] = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    ["<leader>dn"] = { "<cmd>lua require'dap'.step_over()<cr>", "Next" },
    ["<leader>do"] = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
    ["<leader>dp"] = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
    ["<leader>dt"] = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Terminal" },
    ["<leader>du"] = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    ["<leader>dq"] = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    ["<leader>dw"] = { "<cmd>lua require'dapui'.float_element()<cr>", "Float Window" },
  },
}

M.lsp = {
  n = {
    ["[E"] = {
      function()
        vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" } }
      end,
      "prev error",
    },
    ["]E"] = {
      function()
        vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" } }
      end,
      "next error",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "prev diagnostic",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "next diagnostic",
    },
    ["gI"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },
    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "Code Action",
    },
    ["<leader>ld"] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics" },
    ["<leader>lD"] = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
    ["<leader>lf"] = { "<cmd>Neoformat<cr>", "Format" },
    ["<leader>li"] = { "<cmd>LspInfo<cr>", "Info" },
    ["<leader>lI"] = { "<cmd>Mason<cr>", "Installer Info" },
    ["<leader>ll"] = {
      function()
        vim.lsp.codelens.run()
      end,
      "CodeLens Action",
    },
    ["<leader>lq"] = {
      function()
        vim.diagnostic.setloclist { severity = vim.diagnostic.severity.ERROR }
      end,
      "Quickfix Document",
    },
    ["<leader>lQ"] = {
      function()
        vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
      end,
      "Quickfix Workspace",
    },
    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "Rename",
    },
    ["<leader>ls"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    ["<leader>lS"] = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    ["<leader>lO"] = {
      "<cmd>SymbolsOutline<cr>",
      "Symbol Outline",
    },
    ["<leader>lwa"] = {
      vim.lsp.buf.add_workspace_folder,
      "add workspace folder",
    },
    ["<leader>lwr"] = {
      vim.lsp.buf.remove_workspace_folder,
      "remove workspace folder",
    },
    ["<leader>lwl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "list workspace folders",
    },
  },
}

M.gitsigns = {
  n = {
    ["<leader>gl"] = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    ["<leader>gp"] = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    ["<leader>gr"] = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    ["<leader>gR"] = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    ["<leader>gs"] = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    ["<leader>gu"] = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    ["<leader>go"] = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    ["<leader>gc"] = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    ["<leader>gC"] = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)",
    },
    ["<leader>gd"] = {
      "<cmd>Gvdiffsplit<cr>",
      "Git Diff",
    },
    ["<leader>gg"] = { "<cmd>Git<cr>", "   gitfutive" },
  },
}

M.tabufline = {
  n = {
    ["L"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "  goto next buffer",
    },
    ["H"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "  goto prev buffer",
    },
  },
}

M.code = {
  n = {
    ["<leader>pf"] = { "<cmd>lua require('custom.my-plugins.printf').printf()<cr>", "printf" },
  },
}

M.reach = {
  n = {
    ["B"] = { "<cmd>ReachOpen buffers<CR>", "buffers" },
    ["M"] = { "<cmd>ReachOpen marks<CR>", "marks" },
  },
}

M.yanky = {
  n = {
    ["<leader>fy"] = { "<cmd>Telescope yank_history<cr>", "yank history" },
  },
}

return M
