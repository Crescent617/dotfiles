local Util = require "base46.colors"
local M = {}

-- nvchad base46 dracula theme
local base30 = {
  white = "#F8F8F2",
  darker_black = "#222430",
  black = "#282A36", --  nvim bg
  black2 = "#2d303e",
  one_bg = "#373844", -- real bg of onedark
  one_bg2 = "#44475a",
  one_bg3 = "#565761",
  grey = "#5e5f69",
  grey_fg = "#666771",
  grey_fg2 = "#6e6f79",
  light_grey = "#73747e",
  red = "#ff7070",
  baby_pink = "#ff86d3",
  pink = "#FF79C6",
  line = "#3c3d49", -- for lines like vertsplit
  green = "#50fa7b",
  vibrant_green = "#5dff88",
  nord_blue = "#8b9bcd",
  blue = "#a1b1e3",
  yellow = "#F1FA8C",
  sun = "#FFFFA5",
  purple = "#BD93F9",
  dark_purple = "#BD93F9",
  teal = "#92a2d4",
  orange = "#FFB86C",
  cyan = "#8BE9FD",
  statusline_bg = "#2d2f3b",
  lightbg = "#41434f",
  pmenu_bg = "#b389ef",
  folder_bg = "#BD93F9",
}

local rainbow = {
  base30.cyan,
  base30.vibrant_green,
  base30.orange,
  base30.baby_pink,
  base30.purple,
  base30.blue,
}

function M.plugin_render_markdown()
  local ret = {
    -- RenderMarkdownBullet = { fg = c.orange }, -- horizontal rule
    -- RenderMarkdownCode = { bg = c.bg_dark },
    -- RenderMarkdownDash = { fg = c.orange }, -- horizontal rule
    -- RenderMarkdownTableHead = { fg = c.red },
    -- RenderMarkdownTableRow = { fg = c.orange },
    -- RenderMarkdownCodeInline = "@markup.raw.markdown_inline",
  }
  for i, color in ipairs(rainbow) do
    ret["RenderMarkdownH" .. i .. "Bg"] = { bg = Util.mix(color, base30.black, 90) }
    ret["@markup.heading." .. i .. ".markdown"] = { fg = color, bold = true }
  end
  return ret
end

function M.setup()
  local highlights = M.plugin_render_markdown()
  for group, color in pairs(highlights) do
    if type(color) == "string" then
      vim.api.nvim_set_hl(0, group, { link = color })
    else
      vim.api.nvim_set_hl(0, group, color)
    end
  end
end

return M
