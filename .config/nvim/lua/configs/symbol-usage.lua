local function h(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

local function fmt_unit(num, unit)
  return ("%s"):format(num)
end

local function text_format(symbol)
  local res = {}

  local round_start = { "", "SymbolUsageRounding" }
  local round_end = { "", "SymbolUsageRounding" }

  -- Indicator that shows if there are any other symbols in the same line
  local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

  table.insert(res, round_start)
  if symbol.references then
    local s = fmt_unit(symbol.references, "usage")
    table.insert(res, { "󰌹 ", "SymbolUsageRef" })
    table.insert(res, { s, "SymbolUsageContent" })
    table.insert(res, { " ", "SymbolUsageContent" })
  end

  if symbol.definition then
    local s = fmt_unit(symbol.definition, "def")
    table.insert(res, { "󰳽 ", "SymbolUsageDef" })
    table.insert(res, { s, "SymbolUsageContent" })
    table.insert(res, { " ", "SymbolUsageContent" })
  end

  if symbol.implementation then
    local s = fmt_unit(symbol.implementation, "impl")
    -- table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
    table.insert(res, { " ", "SymbolUsageImpl" })
    table.insert(res, { s, "SymbolUsageContent" })
    table.insert(res, { " ", "SymbolUsageContent" })
  end

  if stacked_functions_content ~= "" then
    table.insert(res, { "", "SymbolUsageImpl" })
    table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
    table.insert(res, { " ", "SymbolUsageContent" })
  end

  table.remove(res, #res)
  table.insert(res, round_end)
  return res
end

-- SymbolKind = {
--   File = 1,
--   Module = 2,
--   Namespace = 3,
--   Package = 4,
--   Class = 5,
--   Method = 6,
--   Property = 7,
--   Field = 8,
--   Constructor = 9,
--   Enum = 10,
--   Interface = 11,
--   Function = 12,
--   Variable = 13,
--   Constant = 14,
--   String = 15,
--   Number = 16,
--   Boolean = 17,
--   Array = 18,
--   Object = 19,
--   Key = 20,
--   Null = 21,
--   EnumMember = 22,
--   Struct = 23,
--   Event = 24,
--   Operator = 25,
--   TypeParameter = 26,
-- }
local SymbolKind = vim.lsp.protocol.SymbolKind
local common_kinds = {
  SymbolKind.Interface,
  SymbolKind.Class,
  SymbolKind.Function,
  SymbolKind.Method,
  SymbolKind.Struct,
}

require("symbol-usage").setup {
  text_format = text_format,
  vt_position = "end_of_line",
  request_pending_text = " ...",
  implementation = {
    enabled = true,
  },
  definition = {
    enabled = false,
  },
  kinds = common_kinds,
  filetypes = {
    go = {
      kinds = vim.list_extend({ SymbolKind.Constant }, common_kinds),
    },
    rust = {
      kinds = vim.list_extend({ SymbolKind.Constant, SymbolKind.Enum, SymbolKind.EnumMember }, common_kinds),
    },
  },
}
