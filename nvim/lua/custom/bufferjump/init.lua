local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event
local devicons = require "nvim-web-devicons"

local M = {
  max_files = 20,
  cwd_only = true,
}

local function get_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local buf_set = {}
  for _, buf in ipairs(buffers) do
    buf_set[buf] = true
  end

  local files = {}
  local seen = {}
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local cwd = vim.fn.getcwd()

  -- Get a list of all buffers currently displayed in any window
  local displayed_buffers = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    displayed_buffers[buf] = true
  end

  -- Get the jumplist
  local jumplist = vim.fn.getjumplist()[1]
  local jumplist_positions = {}
  for i, entry in ipairs(jumplist) do
    if buf_set[entry.bufnr] then
      jumplist_positions[entry.bufnr] = { line = entry.lnum, col = entry.col, idx = i }
    end
  end

  table.sort(buffers, function(a, b)
    local i_a = jumplist_positions[a] and jumplist_positions[a].idx or 0
    local i_b = jumplist_positions[b] and jumplist_positions[b].idx or 0
    return i_a > i_b
  end)

  -- Iterate through buffers
  for i, bufnr in ipairs(buffers) do
    if i > M.max_files then
      break
    end
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if
      filename ~= ""
      and filename ~= current_file
      and not displayed_buffers[bufnr]
      and not seen[filename]
      and (not M.cwd_only or vim.fn.fnamemodify(filename, ":p"):find(cwd, 1, true))
      and vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
      -- and vim.api.nvim_get_option_value("modifiable", { buf = bufnr })
    then
      seen[filename] = true
      local pos = jumplist_positions[bufnr] or { line = 1, col = 0 }
      table.insert(files, {
        filename = filename,
        line = pos.line,
        col = pos.col,
      })
    end
  end

  return files
end

M.bufferjump = function()
  local jumplist = get_buffers()
  if #jumplist == 0 then
    vim.notify "No jumpable buffers"
    return
  end

  -- Calculate height based on jumplist length
  local min_height = 5 -- minimum height in lines
  local max_height = M.max_files -- maximum height in lines
  local height = math.min(max_height, math.max(min_height, #jumplist))
  local title = string.format(" Buffer Jump (%d) ", #jumplist)

  local popup = Popup {
    enter = true,
    focusable = true,
    border = {
      style = "solid",
      text = {
        top = title,
      },
    },
    position = "50%",
    size = {
      width = "42%",
      height = height,
    },
    win_options = {
      number = true, -- Enable absolute line numbers
      relativenumber = false, -- Ensure relative line numbers are disabled
    },
  }

  -- mount/open the component
  popup:mount()

  -- unmount component when cursor leaves buffer
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  local lines = {}
  local base_names = {}
  local base_name_count = {}

  -- First pass: count duplicate base names
  for _, entry in ipairs(jumplist) do
    local base_name = vim.fn.fnamemodify(entry.filename, ":t")
    base_name_count[base_name] = (base_name_count[base_name] or 0) + 1
  end

  -- Store jumplist info and prepare display
  popup.jumplist_data = jumplist

  -- Format lines for display
  for i, entry in ipairs(jumplist) do
    local base_name = vim.fn.fnamemodify(entry.filename, ":t")
    local icon, icon_hl = devicons.get_icon(base_name, vim.fn.fnamemodify(base_name, ":e"))
    icon = icon or "" -- fallback icon if none found
    -- Check if file has unsaved changes
    local bufnr = vim.fn.bufnr(entry.filename)
    local modified = bufnr > 0 and vim.bo[bufnr].modified
    local modified_symbol = modified and "[+]" or ""

    local line_text = string.format(" %s %s:%d%s", icon, base_name, entry.line, modified_symbol)
    table.insert(lines, line_text)
    base_names[i] = {
      base_name = base_name,
      is_duplicate = base_name_count[base_name] > 1,
      dir_path = vim.fn.fnamemodify(entry.filename, ":.:h"),
      icon_hl = icon_hl,
    }
  end

  -- Set content once
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  -- Create separate namespaces for icons and virtual text
  local icon_ns = vim.api.nvim_create_namespace "jumplist_icons"
  local virt_ns = vim.api.nvim_create_namespace "jumplist_paths"

  -- Add highlighting for icons
  for i, info in ipairs(base_names) do
    if info.icon_hl then
      vim.api.nvim_buf_add_highlight(popup.bufnr, icon_ns, info.icon_hl, i - 1, 0, 2)
    end
    -- Add virtual text for duplicates using extmark
    vim.api.nvim_buf_set_extmark(popup.bufnr, virt_ns, i - 1, 0, {
      virt_text = { { info.dir_path, "Comment" } },
      virt_text_pos = "eol",
    })
  end

  -- Set popup to read-only
  vim.api.nvim_set_option_value("modifiable", false, { buf = popup.bufnr })

  -- Helper function for buffer-local keymaps
  local function close_popup()
    popup:unmount()
  end

  local function on_buffer(fn, close)
    local current_line = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local jump_entry = popup.jumplist_data[current_line]

    if jump_entry then
      if close then
        close_popup()
      end
      fn(jump_entry)
    end
  end

  local function open_buffer(command)
    on_buffer(function(jump_entry)
      vim.cmd(string.format("%s %s", command, jump_entry.filename))
      -- vim.api.nvim_win_set_cursor(0, { jump_entry.line, jump_entry.col })
    end, true)
  end

  local function map(key, func)
    vim.keymap.set("n", key, func, { buffer = popup.bufnr, noremap = true })
  end

  map("<CR>", function()
    open_buffer "edit"
  end)

  map("v", function()
    open_buffer "vsplit"
  end)

  map("q", close_popup)
  map("<Esc>", close_popup)

  local function jump_to_line(line_num)
    local jump_entry = popup.jumplist_data[line_num]
    if jump_entry then
      close_popup()
      vim.cmd(string.format("edit %s", jump_entry.filename))
      vim.api.nvim_win_set_cursor(0, { jump_entry.line, jump_entry.col })
    else
      vim.notify(string.format("Invalid line number: %d", line_num))
    end
  end

  for i = 1, #jumplist do
    map(tostring(i), function()
      jump_to_line(i)
    end)
  end
end

return M
