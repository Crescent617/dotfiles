local M = {}

M.base46 = {
  theme = "chadracula",
  -- transparency = true,
  hl_override = {
    DiffAdd = { fg = "green", bg = "#123b1a" },
    DiffDelete = { fg = "red" },
    DiffChange = { fg = "orange" },
    WildMenu = { fg = "#6ad8eD", bg = "#30385f" },
    IncSearch = { bg = "#e0af68", fg = "#373640" },
    ["@keyword"] = { italic = true },
    ["@keyword.function"] = { italic = true },
    ["@keyword.return"] = { italic = true },
  },
  theme_toggle = { "chadracula", "one_light" },
}

M.ui = {
  -- lazyload it when there are 1+ buffers
  tabufline = {
    lazyload = false,
  },
  cmp = {
    style = "atom_colored",
  },
}

M.mason = {
  cmd = true,
  pkgs = {
    "bash-language-server",
    "black",
    "codelldb",
    "codespell",
    "css-lsp",
    "json-lsp",
    "lua-language-server",
    "prettier",
    "prosemd-lsp",
    "pyright",
    "shfmt",
    "stylua",
    "yaml-language-server",
    "zk",
    "vim-language-server",
  },
}

return M
