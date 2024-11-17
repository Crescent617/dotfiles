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
o.foldmethod = "indent"
o.foldlevelstart = 99
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
o.sessionoptions = "buffers,curdir,folds,tabpages,winpos,winsize"

g.conflict_marker_enable_mappings = 0
g.loaded_python3_provider = nil

local highlights = {
  -- diagnostics underline
  "hi! DiagnosticUnderlineError guisp=#FF5555 gui=undercurl",
  "hi! DiagnosticUnderlineWarn guisp=#e0af68 gui=undercurl",
  "hi! DiagnosticUnderlineInfo guisp=#6ad8ed gui=undercurl",
  "hi! DiagnosticUnderlineHint guisp=#bd93f9 gui=undercurl",

  -- diagnostics vt
  "hi! DiagnosticVirtualTextError guifg=#FF5555 guibg=#362C3D",
  "hi! DiagnosticVirtualTextWarn guifg=#e0af68 guibg=#373640",
  "hi! DiagnosticVirtualTextInfo guifg=#6ad8eD guibg=#30385f",
  "hi! DiagnosticVirtualTextHint guifg=#bd93f9 guibg=#3d3059",

  -- diagnostics signs
  "hi! DiagnosticSignError guifg=#FF5555",
  "hi! DiagnosticSignWarn guifg=#e0af68",
  "hi! DiagnosticSignInfo guifg=#6ad8ed",
  "hi! DiagnosticSignHint guifg=#bd93f9",
}

local autocmds = {
  { "UIEnter", "*", table.concat(highlights, " | ") },
  { "InsertLeave", "*", ":set relativenumber" },
  { "InsertEnter", "*", ":set norelativenumber" },
  -- { "InsertLeave", "*", ":lua vim.diagnostic.show(nil, 0)" },
  -- { "InsertEnter", "*", ":lua vim.diagnostic.hide(nil, 0)" },
}

for _, v in ipairs(autocmds) do
  vim.api.nvim_create_autocmd(v[1], { pattern = v[2], command = v[3] })
end

-- lsp inlay_hint
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable()
    end
    -- whatever other lsp config you want
  end,
})

-- GUI
if g.neovide then
  o.guifont = "JetBrainsMono Nerd Font"
  g.neovide_remember_window_size = true
  g.neovide_cursor_vfx_mode = "railgun"
  g.neovide_confirm_quit = true
  g.neovide_input_use_logo = 1
  g.neovide_no_idle = true

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
