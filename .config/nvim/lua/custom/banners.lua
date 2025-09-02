local M = {}

local banner_footer = {
  "                            ",
  "     Powered By  eovim    ",
  "                            ",
}

-- example.txt#tag1,tag2
local function get_tags(filename)
  local tags = {}
  local parts = vim.split(filename, "#")
  if #parts > 1 then
    tags = vim.split(parts[2], ",")
  end
  return tags
end

local function padding_lines(lines)
  -- max_length in unicode characters
  local max_length = 0
  for _, line in ipairs(lines) do
    local len = vim.fn.strdisplaywidth(line)
    if len > max_length then
      max_length = len
    end
  end

  local new_lines = {}
  for _, line in ipairs(lines) do
    local padding = string.rep(" ", max_length - vim.fn.strdisplaywidth(line))
    table.insert(new_lines, line .. padding)
  end
  return new_lines
end

M._filter_disbaled_files = function(files)
  local filtered = {}
  for _, file in ipairs(files) do
    local tags = get_tags(file)
    if not vim.tbl_contains(tags, "x") then
      table.insert(filtered, file)
    end
  end
  return filtered
end

M.pick = function()
  local banner_path = vim.fn.stdpath "config" .. "/assets/banners"
  local files = vim.fn.readdir(banner_path)
  files = M._filter_disbaled_files(files)

  if #files == 0 then
    return { "Hello Neovim!" }
  end

  local picked = require("custom.lib.rand").pick(files)
  local lines = vim.fn.readfile(banner_path .. "/" .. picked)
  lines = padding_lines(lines)
  return vim.list_extend(lines, banner_footer)
end

return M
