local M = {}

-- ## Git Rebase Squash
local function register_git_rabase_squash()
  vim.api.nvim_buf_create_user_command(0, "GitRebaseSquash", function()
    -- 获取当前缓冲区的所有行内容
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local cnt = 0
    -- 遍历行，替换 "pick" 为 "squash"（保留第一行且跳过注释行）
    for i = 2, #lines do
      if lines[i]:match "^pick" then
        lines[i] = lines[i]:gsub("^pick", "squash")
        cnt = cnt + 1
      end
    end

    -- 将修改后的内容写回缓冲区
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    vim.notify(string.format("Replaced %d 'pick' with 'squash'", cnt))
  end, { desc = "Replace 'pick' with 'squash' in non-comment git rebase lines" })
end

local function register_lsp_diagnostic()
  vim.api.nvim_create_user_command("LspMultiLineDiagnosticToggle", function()
    local current = vim.diagnostic.config().virtual_lines
    if current then
      vim.diagnostic.config { virtual_lines = false, virtual_text = true }
    else
      vim.diagnostic.config { virtual_lines = { only_current_line = true }, virtual_text = false }
    end
  end, { desc = "Toggle multi-line LSP diagnostics" })
end

local function register_qftf()
  local fn = vim.fn

  function _G.qftf(info)
    local items
    local ret = {}
    -- The name of item in list is based on the directory of quickfix window.
    -- Change the directory for quickfix window make the name of item shorter.
    -- It's a good opportunity to change current directory in quickfixtextfunc :)
    --
    -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
    -- local root = getRootByAlterBufnr(alterBufnr)
    -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))

    if info.quickfix == 1 then
      items = fn.getqflist({ id = info.id, items = 0 }).items
    else
      items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s │%5d:%-3d│%s %s"
    for i = info.start_idx, info.end_idx do
      local e = items[i]
      local fname = ""
      local str
      if e.valid == 1 then
        if e.bufnr > 0 then
          fname = fn.bufname(e.bufnr)
          if fname == "" then
            fname = "[No Name]"
          else
            fname = fname:gsub("^" .. vim.env.HOME, "~")
          end
          -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
          if #fname <= limit then
            fname = fnameFmt1:format(fname)
          else
            fname = fnameFmt2:format(fname:sub(1 - limit))
          end
        end
        local lnum = e.lnum > 99999 and -1 or e.lnum
        local col = e.col > 999 and -1 or e.col
        local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
        str = validFmt:format(fname, lnum, col, qtype, e.text)
      else
        str = e.text
      end
      table.insert(ret, str)
    end
    return ret
  end

  vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
end

function M.setup()
  vim.cmd [[
    command! DiffOrig w !diff -u % -
    command! DiffOrigVim vert new | setlocal buftype=nofile | setlocal nobuflisted | read ++edit # | 0d_ | diffthis | wincmd p | diffthis | wincmd p

    function! QuickFixToggle()
      if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
      else
        cclose
      endif
    endfunction
  ]]

  register_lsp_diagnostic()
  -- register_qftf()

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitrebase",
    callback = register_git_rabase_squash,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "jsonc",
    callback = function()
      vim.bo.commentstring = "// %s"
    end,
  })
  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "Caddyfile",
    callback = function()
      vim.bo.filetype = "caddy"
      vim.bo.commentstring = "# %s"
    end,
  })

  -- lsp
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function()
      vim.lsp.inlay_hint.enable()
    end,
  })
end

return M
