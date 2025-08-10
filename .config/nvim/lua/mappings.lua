require "nvchad.mappings"

local lsputil = require "custom.lsputil"

local map = vim.keymap.set
local del = vim.keymap.del

-- ===========================
-- Delete existing mappings
-- ===========================
del("n", "<leader>wk")
del("n", "<leader>wK")
del("n", "<leader>v")
del("n", "<leader>h")
del("n", "<leader>n")
del("n", "<Tab>")
del("i", "<C-l>")
del("i", "<C-h>")
del("i", "<C-j>")
del("i", "<C-k>")
del("n", "<C-c>")
del("n", "grn")
del("n", "gri")
del("n", "gra")
del("n", "grr")
-- del("n", "<C-l>")

-- ===========================
-- General mappings
-- ===========================
map({ "n", "x" }, ";", ":", { desc = "CMD enter command mode" })
map("n", "P", '"0p', { desc = "paste from yank register" })
map("t", "jk", [[<C-\><C-n>]]) -- jk to escape in terminal mode

-- search in range
map("x", "/", function()
  -- 退出 visual 模式
  vim.cmd 'exe "normal! \\<Esc>"'

  -- get visoal selection start and end line
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"
  local prefix = "\\%>" .. start_line .. "l\\%<" .. end_line .. "l"

  local pattern = prefix .. vim.fn.input("<" .. start_line .. "," .. end_line .. ">  ")
  vim.fn.setreg("/", pattern)
  vim.fn.search(pattern)
end, {})

-- open floating terminal
-- map({ "n", "t" }, "<A-i>", "<cmd>ToggleTerm direction=float<cr>", { desc = "terminal toggle floating term" })

-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})

map("n", "<C-q>", "<cmd>call QuickFixToggle()<CR>", { desc = "Toggle Quickfix" })
-- map("n", "<C-w>z", "<cmd>resize | vertical resize<CR>", { desc = "Zoom in window" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "quit" })
map("n", "<leader>Q", "<cmd>qall<CR>", { desc = "quit all" })
map("n", "<leader>w", "<cmd>update<CR>", { desc = "save" })
map("n", "<leader>.", ":@:<CR>", { noremap = true, silent = true, desc = "repeat last command" })

map("n", "<leader>tp", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Problems" }) -- show only errors
map("n", "<leader>b", "<cmd>b#<CR>", { desc = "last buffer" })
map("n", "<Esc>", "<cmd>nohl<CR>", { desc = "nohl" })

map("n", "<leader>S", "<cmd>lua require('grug-far').open({ transient = true })<CR>", { desc = "Search & Replace" })
map(
  "v",
  "<leader>S",
  "<cmd>lua require('grug-far').with_visual_selection({ transient = true })<CR>",
  { desc = "Search & Replace" }
)

-- ===========================
-- Neotest mappings
-- ===========================
map("n", "<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = "Test File" })
map("n", "<leader>tn", '<cmd>lua require("neotest").run.run()<CR>', { desc = "Test Nearest" })
map("n", "<leader>to", '<cmd>lua require("neotest").output.open({ enter = true })<CR>', { desc = "Show Test Output" })
map("n", "<leader>ta", '<cmd>lua require("neotest").run.attach()<CR>', { desc = "Attach Test" })
map("n", "<leader>ts", '<cmd>lua require("neotest").run.stop()<CR>', { desc = "Stop Test" })
map("n", "<leader>tt", '<cmd>lua require("neotest").summary.toggle()<CR>', { desc = "Toggle Test Outline" })

-- ===========================
-- DAP (Debug Adapter Protocol) mappings
-- ===========================
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dS", "<cmd>lua require'dap'.step_back()<CR>", { desc = "Step Back" })
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Continue" })
map("n", "<leader>dC", "<cmd>lua require'dap'.run_to_cursor()<CR>", { desc = "Run To Cursor" })
map("n", "<leader>dd", "<cmd>lua require'dap'.disconnect()<CR>", { desc = "Disconnect" })
map("n", "<leader>dg", "<cmd>lua require'dap'.session()<CR>", { desc = "Get Session" })
map("n", "<leader>ds", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Step Into" })
map("n", "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Next" })
map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Step Out" })
map("n", "<leader>dp", "<cmd>lua require'dap'.pause()<CR>", { desc = "Pause" })
map("n", "<leader>dt", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "Toggle Terminal" })
map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle UI" })
map("n", "<leader>dq", "<cmd>lua require'dap'.close()<CR>", { desc = "Quit" })
map("n", "<leader>dw", "<cmd>lua require'dapui'.float_element()<CR>", { desc = "Float Window" })

-- ===========================
-- Diagnostic mappings
-- ===========================
map("n", "[E", function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" }, count = -1 }
end, { desc = "prev error" })
map("n", "]E", function()
  vim.diagnostic.jump { severity = vim.diagnostic.severity.ERROR, float = { border = "rounded" }, count = 1 }
end, { desc = "next error" })
map("n", "[d", function()
  vim.diagnostic.jump { float = { border = "rounded" }, count = -1 }
end, { desc = "prev diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump { float = { border = "rounded" }, count = 1 }
end, { desc = "next diagnostic" })

-- ===========================
-- LSP (Language Server Protocol) mappings
-- ===========================
map("n", "gI", vim.lsp.buf.implementation, { desc = "lsp implementation" })

map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })

map("n", "<leader>lA", lsputil.action.source, { desc = "Src action" })

-- map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Buffer Diagnostics" })
-- map("n", "<leader>lD", "<cmd>Telescope diagnostics<CR>", { desc = "Workspace Diagnostics" })
map("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "Info" })
map("n", "<leader>lI", "<cmd>Mason<CR>", { desc = "Installer Info" })
map("n", "<leader>ll", function()
  vim.lsp.codelens.run()
end, { desc = "CodeLens Action" })
map("n", "<leader>lq", function()
  vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
end, { desc = "Quickfix Document" })
map("n", "<leader>lQ", function()
  vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
end, { desc = "Quickfix Workspace" })
-- map("n", "<leader>lr", require "nvchad.lsp.renamer", { desc = "Rename" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
-- map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document Symbols" })
-- map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Workspace Symbols" })
map("n", "<leader>lO", "<cmd>SymbolsOutline<CR>", { desc = "Symbol Outline" })

map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
map("n", "<leader>lwl", function()
  vim.print(vim.lsp.buf.list_workspace_folders())
end, { desc = "list workspace folders" })

-- ===========================
-- Git mappings
-- ===========================
map("n", "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", { desc = "Preview Hunk" })
map("n", "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", { desc = "Reset Hunk" })
map("n", "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", { desc = "Reset Buffer" })
map("n", "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", { desc = "Stage Hunk" })
map("n", "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", { desc = "Undo Stage Hunk" })
-- map("n", "<leader>go", "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
-- map("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>", { desc = "Checkout commit (Cur File)" })
-- map("n", "<leader>gC", "<cmd>Telescope git_commits<cr>", { desc = "Checkout commit" })
map("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Git Diff" })
map("n", "<leader>gb", "<cmd>lua Snacks.git.blame_line()<cr>", { desc = "Blame Line" })
map("n", "<leader>gl", "<cmd>lua Snacks.picker.git_log()<cr>", { desc = "Git Log" })
map("n", "<leader>gL", "<cmd>lua Snacks.picker.git_log_line()<cr>", { desc = "Git Log Line" })
map("n", "<leader>gS", "<cmd>lua Snacks.picker.git_stash()<cr>", { desc = "Git Stash" })
map("n", "<leader>gf", "<cmd>lua Snacks.picker.git_log_file()<cr>", { desc = "Git Log File" })
map("n", "<leader>gD", "<cmd>lua Snacks.picker.git_diff()<cr>", { desc = "Git Diff (Hunks)" })

-- map("n", "<leader>gg", "<cmd>Git<cr>", { desc = "gitfutive" })
map("n", "<leader>gg", "<cmd>lua Snacks.lazygit()<cr>", { desc = "LazyGit" })

-- ===========================
-- Buffer navigation mappings
-- ===========================
map("n", "L", "<cmd>lua require('nvchad.tabufline').next()<cr>", { desc = "  goto next buffer" })
map("n", "H", "<cmd>lua require('nvchad.tabufline').prev()<cr>", { desc = "  goto prev buffer" })

-- ===========================
-- Telescope mappings
-- ===========================
map("n", "<leader>fy", "<cmd>Telescope yank_history<cr>", { desc = "yank history" })
map("n", "<leader><space>", "<cmd>Telescope find_files<cr>", { desc = "find files" })

-- ===========================
-- Gitsigns mappings
-- ===========================
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "  next_hunk" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "  prev_hunk" })
