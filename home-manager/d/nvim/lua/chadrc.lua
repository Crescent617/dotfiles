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

M.nvdash = {
  load_on_startup = true,
  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    -- { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    -- { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "  Sessions", keys = "s", cmd = "Telescope persisted" },
    { txt = "󰒲  lazy", keys = "L", cmd = "Lazy" },
    { txt = "󰭻  Load Session", keys = "l", cmd = "lua require('configs.util').load_session_for_cwd()" },
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
    "bash-language-server",
    "codelldb",
    "css-lsp",
    "json-lsp",
    "lua-language-server",
    "prosemd-lsp",
    "pyright",
    "yaml-language-server",
    "zk",
    "vim-language-server",
    -- formatter
    "gofumpt",
    "black",
    "prettier",
    "shfmt",
    "stylua",
    -- lint
    "codespell",
  },
}

return M