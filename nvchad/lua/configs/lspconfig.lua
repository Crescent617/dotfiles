local servers = {
  "vimls",
  "html",
  "cssls",
  "bashls",
  "pyright",
  "gopls",
  "tsserver",
  "jsonls",
  "yamlls",
  "taplo",
  "prosemd_lsp",
  "eslint",
  "rust_analyzer",
}

local conf = require("nvconfig").ui.lsp
local map = vim.keymap.set
local navic = require "nvim-navic"

local on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = desc }
  end

  map("n", "K", vim.lsp.buf.hover, opts "Lsp hover information")
  map("n", "gd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "gI", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
  map("n", "gr", vim.lsp.buf.references, opts "Lsp Show references")
  map("n", "gD", vim.lsp.buf.type_definition, opts "Lsp Go to type definition")
  -- map("n", "gD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")

  -- setup signature popup
  if conf.signature and client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
  end
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local configs = require "nvchad.configs.lspconfig"
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Lua with vim
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
