require "nvchad.options"

-- add yours here!

local o = vim.o
local g = vim.g

-- vim config
vim.cmd [[
  command! DiffOrig w !diff -u % -
  command! DiffOrigVim vert new | setlocal buftype=nofile | setlocal nobuflisted | read ++edit # | 0d_ | diffthis | wincmd p | diffthis | wincmd p
  command! -range -nargs=1 SearchInRange /\%><line1>l\%<<line2>l<args>
  packadd cfilter

  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

o.cmdheight = 1 -- more space in the neovim command line for displaying messages
o.confirm = true
o.swapfile = false
o.scrolloff = 8
o.wrap = true
o.relativenumber = true
o.shell = "zsh"
o.list = true
-- opt.updatetime = 512
-- opt.timeoutlen = 400
-- o.spell = true
-- o.spelloptions = "camel,noplainbuffer"
o.sessionoptions = "buffers,curdir,tabpages,winpos,winsize"
o.jumpoptions = "stack"

-- [[ fold settings
o.foldenable = true
o.foldlevelstart = 99
local disable_expr_fold_ft = { "codecompanion", "Avante" }
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.tbl_contains(disable_expr_fold_ft, vim.bo[args.buf].filetype) then
      return
    end
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldmethod = "expr"
    if client and client:supports_method "textDocument/foldingRange" then
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    else
      vim.wo[win][0].foldexpr = "nvim_treesitter#foldexpr()"
    end
  end,
})
-- ]]

g.loaded_python3_provider = nil

-- [[ custom
require "custom.command" -- TODO: use lazy.nvim to load this
-- ]]

local colors = {
  red = "#FF6555",
  yellow = "#e0af68",
  cyan = "#6ad8ed",
  purple = "#bd93f9",
  red_bg = "#362C3D",
  yellow_bg = "#373640",
  cyan_bg = "#30385f",
  purple_bg = "#3d3059",
}

local highlights = {
  -- diagnostics underline
  { "DiagnosticUnderlineError", { sp = colors.red, undercurl = true } },
  { "DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true } },
  { "DiagnosticUnderlineInfo", { sp = colors.cyan, undercurl = true } },
  { "DiagnosticUnderlineHint", { sp = colors.purple, undercurl = true } },

  -- diagnostics vt
  { "DiagnosticVirtualTextError", { fg = colors.red, bg = colors.red_bg } },
  { "DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.yellow_bg } },
  { "DiagnosticVirtualTextInfo", { fg = colors.cyan, bg = colors.cyan_bg } },
  { "DiagnosticVirtualTextHint", { fg = colors.purple, bg = colors.purple_bg } },

  -- diagnostics signs
  { "DiagnosticError", { fg = colors.red } },
  { "DiagnosticWarn", { fg = colors.yellow } },
  { "DiagnosticInfo", { fg = colors.cyan } },
  { "DiagnosticHint", { fg = colors.purple } },
}

local function set_highlights()
  for _, highlight in ipairs(highlights) do
    vim.api.nvim_set_hl(0, highlight[1], highlight[2])
  end
end

local function switch_relative_number(b)
  return function()
    if vim.wo.number then
      vim.wo.relativenumber = b
    end
  end
end

local autocmds = {
  { "UIEnter", "*", set_highlights },
  { "InsertLeave", "*", switch_relative_number(true) },
  { "InsertEnter", "*", switch_relative_number(false) },
  -- { "InsertLeave", "*", function() vim.diagnostic.show(nil, 0) end },
  -- { "InsertEnter", "*", function() vim.diagnostic.hide(nil, 0) end },
}

for _, v in ipairs(autocmds) do
  vim.api.nvim_create_autocmd(v[1], { pattern = v[2], callback = v[3] })
end

-- lsp inlay_hint
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client and client.server_capabilities.inlayHintProvider then
--       vim.lsp.inlay_hint.enable()
--     end
--     -- whatever other lsp config you want
--   end,
-- })

-- GUI
if g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
  vim.o.linespace = 6

  g.neovide_remember_window_size = true
  g.neovide_cursor_vfx_mode = "railgun"
  g.neovide_confirm_quit = true

  vim.cmd [[
    let g:dracula#palette          = {}
    let g:dracula#palette.color_0  = '#21222C'
    let g:dracula#palette.color_1  = '#FF5555'
    let g:dracula#palette.color_2  = '#50FA7B'
    let g:dracula#palette.color_3  = '#F1FA8C'
    let g:dracula#palette.color_4  = '#BD93F9'
    let g:dracula#palette.color_5  = '#FF79C6'
    let g:dracula#palette.color_6  = '#8BE9FD'
    let g:dracula#palette.color_7  = '#F8F8F2'
    let g:dracula#palette.color_8  = '#6272A4'
    let g:dracula#palette.color_9  = '#FF6E6E'
    let g:dracula#palette.color_10 = '#69FF94'
    let g:dracula#palette.color_11 = '#FFFFA5'
    let g:dracula#palette.color_12 = '#D6ACFF'
    let g:dracula#palette.color_13 = '#FF92DF'
    let g:dracula#palette.color_14 = '#A4FFFF'
    let g:dracula#palette.color_15 = '#FFFFFF'

    if has('nvim')
      for s:i in range(16)
        let g:terminal_color_{s:i} = g:dracula#palette['color_' . s:i]
      endfor
    endif
  ]]

  vim.cmd [[
    imap <D-v> <C-R>+
    tmap <D-v> <C-R>+
    imap <C-v> <C-R>+
    tmap <C-v> <C-R>+
    imap <C-S-v> <C-R>+
    tmap <C-S-v> <C-R>+
    map ˙ <a-h>
    map ∆ <a-j>
    map ˚ <a-k>
    map ¬ <a-l>
    map √ <a-v>
    map ˆ <a-i>
    tmap √ <a-v>
    tmap ˆ <a-i>
  ]]
end

-- tmux
vim.cmd [[
  if has("termguicolors")
    set termguicolors
  endif
]]
