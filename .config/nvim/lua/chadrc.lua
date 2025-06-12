local M = {}

local telescopeInputFg = "pink"

M.base46 = {
  theme = "chadracula",
  -- transparency = true,
  hl_override = {
    DiffAdd = { fg = "green", bg = "#123b1a" },
    DiffText = { bg = "orange", fg = "black" },
    DiffDelete = { fg = "red" },
    DiffChange = { fg = "orange" },
    Folded = { link = "DiagnosticVirtualTextInfo" },
    ["@keyword"] = { italic = true },
    ["@keyword.function"] = { link = "@keyword" },
    ["@keyword.return"] = { link = "@keyword" },
    ["@keyword.conditional"] = { link = "@keyword" },
    ["@keyword.repeat"] = { link = "@keyword" },
    TelescopePromptTitle = { bg = telescopeInputFg, fg = "#000000" },
    TelescopePromptPrefix = { fg = telescopeInputFg },
    NvDashFooter = { fg = "blue" },
  },
  theme_toggle = { "chadracula", "one_light" },
}

M.ui = {
  -- lazyload it when there are 1+ buffers
  tabufline = {
    lazyload = true,
  },
  cmp = {
    style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
  },
  statusline = {
    modules = {
      lsp_msg = function()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        for _, client in ipairs(clients) do
          if client.name == "copilot" then
            return "  Take it lazy 󰒲 "
          end
        end
        return "  Take it easy !"
      end,
    },
  },
}

M.term = {
  float = {
    row = 0.075,
    col = 0.1,
    width = 0.8,
    height = 0.8,
    border = "rounded",
  },
}

local mario_header = {
  "⬛🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨⬛",
  "🟨⬛🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨⬛🟨",
  "🟨🟨🟨🟨⬜⬜⬜⬜⬜⬜⬜🟨🟨🟨",
  "🟨🟨⬜⬜⬜⬜⬜⬜⬜⬜⬜🟨🟨🟨",
  "🟨🟨⬜⬜⬜⬛⬛⬛⬜⬜⬜⬛🟨🟨",
  "🟨🟨🟨⬛⬛⬛🟨🟨⬜⬜⬜⬛🟨🟨",
  "🟨🟨🟨🟨🟨⬜⬜⬜⬜⬜⬛⬛🟨🟨",
  "🟨🟨🟨🟨🟨⬜⬜⬜⬛⬛⬛🟨🟨🟨",
  "🟨🟨🟨🟨🟨🟨⬛⬛⬛🟨🟨🟨🟨🟨",
  "🟨🟨🟨🟨🟨⬜⬜⬜🟨🟨🟨🟨🟨🟨",
  "🟨🟨🟨🟨🟨⬜⬜⬜⬛🟨🟨🟨🟨🟨",
  "🟨🟨🟨🟨🟨⬛⬛⬛⬛🟨🟨🟨🟨🟨",
  "🟨⬛🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨⬛🟨",
  "⬛🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨🟨⬛",
  "                            ",
  "     Powered By  eovim    ",
  "                            ",
}

local kirby_header = {
  "                    🟦🟦🟦🟦🟦            ",
  "                🟦🟦⬜⬜⬜⬜⬜🟦🟦        ",
  "              🟦⬜⬜⬜⬜⬜⬜⬜⬜⬜🟦      ",
  "            🟦⬜⬜⬜⬜⬜🟦🟦⬜🟦🟦⬜🟦    ",
  "            ⬜⬜⬜⬜⬜⬜⬜🟦⬜⬜🟦⬜🟦    ",
  "          🟦⬜⬜⬜⬜⬜⬜🟦⬛⬜🟦⬛⬜⬜🟦  ",
  "          ⬜⬜⬜⬜⬜⬜⬜🟦⬛⬜🟦⬛⬜⬜🟦  ",
  "        ⬜⬜⬜⬜⬜⬜🟦🟦⬜⬜⬜⬜⬜⬜⬜🟦🟦",
  "      ⬜⬜🟦⬜⬜⬜⬜⬜🟦🟦⬜⬜🟦⬜⬜⬜🟦⬜",
  "    ⬜⬜🟦🟦⬜⬜⬜⬜⬜⬜🟦⬜⬜⬜⬜⬜🟦🟦🟦",
  "  ⬜⬜🟦🟦🟦⬜⬜⬜⬜⬜⬜🟦⬜⬜⬜⬜🟦🟦🟦  ",
  "🟦⬜🟦🟦🟦🟦⬜⬜⬜⬜🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦  ",
  "      🟦⬜⬜⬜🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦        ",
  "        🟦⬜🟦🟦🟦🟦🟦🟦🟦🟦🟦🟦          ",
  "                🟦🟦🟦🟦    🟦            ",
  "                                          ",
  "                            ",
  "     Powered By  eovim    ",
  "                            ",
}

M.nvdash = {
  header = kirby_header,
  load_on_startup = true,
  buttons = {
    { txt = "  AI Chat", keys = "a", cmd = "lua vim.cmd'CodeCompanionChat Toggle'; vim.cmd'wincmd p | q'" },
    { txt = "  New File", keys = "n", cmd = "enew" },
    { txt = "  Find File", keys = "f", cmd = "lua Snacks.picker.files()" },
    { txt = "󰈭  Find Word", keys = "w", cmd = "lua Snacks.picker.grep()" },
    -- { txt = "  Recent Files", keys = "r", cmd = "lua Snacks.picker.recent()" },
    -- { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    -- { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "󰒲  lazy", keys = "L", cmd = "Lazy" },
    { txt = "󰭻  Load Session", keys = "l", cmd = "lua require('configs.util').load_session_for_cwd()" },
    { txt = "  Sessions", keys = "s", cmd = "Telescope persisted" },
    { txt = "󰗼  Quit", keys = "q", cmd = "q" },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.mason = {
  cmd = true,
  pkgs = {
    "ast-grep", -- AST-based code searching tool
    "bash-language-server", -- Language server for Bash
    -- "black", -- Python code formatter
    "codelldb", -- LLDB-based debugger
    "codespell", -- Spell checker for source code
    "css-lsp", -- Language server for CSS
    "eslint-lsp", -- Language server for ESLint
    "gofumpt", -- Formatter for Go code
    "goimports", -- Tool for updating Go import lines
    "golangci-lint", -- Linter for Go
    "golangci-lint-langserver", -- Language server for golangci-lint
    "golines", -- Formatter for Go code to shorten lines
    "gopls", -- Go language server
    "helm-ls", -- Language server for Helm
    "html-lsp", -- Language server for HTML
    -- "isort", -- Python import sorter
    "json-lsp", -- Language server for JSON
    "lua-language-server", -- Language server for Lua
    "nil", -- Nix language server
    "prettier", -- Code formatter supporting multiple languages
    "prettierd", -- Prettier daemon for faster formatting
    "prosemd-lsp", -- Language server for Markdown prose
    "pyright", -- Python type checker and language server
    "rnix-lsp", -- Language server for Nix
    "ruff", -- Python linter and formatter
    "rust-analyzer", -- Language server for Rust
    "shfmt", -- Shell script formatter
    "sqlfluff", -- SQL linter and formatter
    "stylua", -- Lua code formatter
    "svelte-language-server", -- Language server for Svelte
    "tailwindcss-language-server", -- Language server for Tailwind CSS
    "taplo", -- Language server for TOML
    "typescript-language-server", -- Language server for TypeScript
    "vim-language-server", -- Language server for Vim script
    "vue-language-server", -- Language server for Vue.js
    "yaml-language-server", -- Language server for YAML
    "zk", -- Plain text note-taking assistant
  },
}

-- NOTE: this is not nvchad official option
M.tree_sitter = {
  ensure_installed = {
    "bash",
    "c",
    "css",
    "go",
    "helm",
    "html",
    "http",
    "javascript",
    "json",
    "just",
    "kdl",
    "latex",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "rust",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
}

return M
