local present, null_ls = pcall(require, "null-ls")

if not present then
   return
end

local b = null_ls.builtins

local sources = {
   b.formatting.shfmt,
   -- b.formatting.stylua,
   b.formatting.black,
   b.formatting.clang_format.with {
      filetypes = { "proto" },
   },
   b.formatting.pg_format,
   b.formatting.prettier.with {
      extra_filetypes = { "markdown" },
      disabled_filetypes = { "json" },
   },
   b.completion.spell.with {
      filetypes = { "markdown" },
   },
   b.diagnostics.codespell.with {
      diagnostics_postprocess = function(diagnostic)
         diagnostic.severity = vim.diagnostic.severity.HINT
      end,
      -- extra_args = { "-I", vim.fn.stdpath('config').."/spell/en.utf-8.add" },
   },
}

null_ls.setup {
   debug = true,
   sources = sources,
}
