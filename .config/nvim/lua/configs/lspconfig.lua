local mason_path = vim.fs.joinpath(vim.fn.stdpath "data", "mason")
local vue_language_server_path =
  vim.fs.joinpath(mason_path, "packages/vue-language-server/node_modules/@vue/language-server")

-- ======================= LSP CONFIGURATION =======================
local servers = {
  vimls = {},
  html = {},
  cssls = {},
  bashls = {},
  pyright = {},
  -- pylyzer = {},
  gopls = {},
  ts_ls = {
    config = {
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "vue" },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    },
  },
  jsonls = {},
  yamlls = {},
  taplo = {},
  -- prosemd_lsp = {},
  eslint = {},
  -- rust_analyzer = {},
  tailwindcss = {},
  rnix = {},
  volar = { disable_default = true },
  helm_ls = {},
  golangci_lint_ls = {},
  svelte = {},
}

-- ======================= LSP HANDLER =======================

local map = vim.keymap.set
local navic = require "nvim-navic"
local hover_func = require("custom.lsputil").hover

local on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "K", hover_func, opts "Lsp hover information")
  map("n", "gd", vim.lsp.buf.definition, opts "Lsp Go to definition")
  map("n", "gI", vim.lsp.buf.implementation, opts "Lsp Go to implementation")
  map("n", "gr", vim.lsp.buf.references, opts "Lsp Show references")
  map("n", "gD", vim.lsp.buf.type_definition, opts "Lsp Go to type definition")
  -- map("n", "gD", vim.lsp.buf.declaration, opts "Lsp Go to declaration")
  map("n", "<leader>lth", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    vim.notify("Inlay hints " .. (vim.lsp.inlay_hint.is_enabled() and "enabled" or "disabled"), nil, {
      title = "LSP",
    })
  end, opts "Toggle Lsp Inlay hints")

  -- setup signature popup
  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.lsp.signature").setup(client, bufnr)
    map("n", "<leader>lh", vim.lsp.buf.signature_help, opts "Lsp Signature help")
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  client.server_capabilities.semanticTokensProvider = nil

  require("nvchad.lsp").diagnostic_config()
end

local configs = require "nvchad.configs.lspconfig"
local on_init = configs.on_init
local capabilities = configs.capabilities

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
}

local lspconfig = require "lspconfig"

for lsp, setting in pairs(servers) do
  local custom_config = setting.config or {}
  if not setting.disable_default then
    custom_config = vim.tbl_extend("force", default_config, custom_config)
  end
  lspconfig[lsp].setup(custom_config)
end

-- Lua with vim
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "Snacks" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          [vim.fn.stdpath "data" .. "/lazy/snacks.nvim/lua/snacks"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

return { on_attach = on_attach }
