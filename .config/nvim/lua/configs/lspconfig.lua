local mason_path = vim.fs.joinpath(vim.fn.stdpath "data", "mason")
vim.lsp.set_log_level "WARN"

-- ======================= LSP CONFIGURATION =======================
local vue_language_server_path =
  vim.fs.joinpath(mason_path, "packages/vue-language-server/node_modules/@vue/language-server")
local svelte_plugin_path =
  vim.fs.joinpath(mason_path, "packages/svelte-language-server/node_modules/node_modules/typescript-svelte-plugin")

local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
local svelte_plugin = {
  name = "typescript-svelte-plugin",
  location = svelte_plugin_path,
}

local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" }
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
          svelte_plugin,
        },
      },
    },
  },
  filetypes = tsserver_filetypes,
}

local server_settings = {
  vimls = {},
  html = {},
  cssls = {},
  bashls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library",
          },
        },
      },
    },
  },
  pyright = {},
  -- pylyzer = {},
  gopls = {},
  -- ts_ls = ts_ls_config,
  svelte = {},
  vue_ls = {},
  vtsls = vtsls_config,
  yamlls = {},
  taplo = {},
  -- prosemd_lsp = {},
  eslint = {},
  -- rust_analyzer = {},
  tailwindcss = {},
  rnix = {},
  helm_ls = {}, -- use helm-ls.nvim
  golangci_lint_ls = {},
  buf_ls = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  glsl_analyzer = {}, -- glsl language server
  zls = {}, -- zig language server
}

-- ======================= LSP KEYMAPS =======================
local map = vim.keymap.set
local util = require "custom.lsputil"

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end

    map("n", "K", util.hover, opts "Hover information")
    map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    map("n", "gI", vim.lsp.buf.implementation, opts "Go to implementation")
    map("n", "gr", vim.lsp.buf.references, opts "Go to references")
    map("n", "gD", vim.lsp.buf.type_definition, opts "Go to type definition")

    -- if client.server_capabilities.documentSymbolProvider then
    --   local navic = require "nvim-navic"
    --   navic.attach(client, bufnr)
    -- end
  end,
})

-- ======================= DIAGNOSTIC CONFIGURATION =======================
local x = vim.diagnostic.severity
vim.diagnostic.config {
  virtual_text = { prefix = "" },
  signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  underline = true,
  float = { border = "single" },
}

-- ======================= ENABLE LSP SERVERS =======================
for lsp, settings in pairs(server_settings) do
  -- if settings is not empty, then set it
  if next(settings) ~= nil then
    vim.lsp.config(lsp, settings)
  end
  vim.lsp.enable(lsp)
end
