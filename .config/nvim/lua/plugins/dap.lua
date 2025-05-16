---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapLogPoint", { text = "󰨯 ", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = " ", texthl = "DiagnosticInfo" })

      require("nvim-dap-virtual-text").setup {}
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup {}
      vim.api.nvim_create_user_command("DapEval", 'lua require("dapui").eval()', {})
    end,
  },
  { "theHamsta/nvim-dap-virtual-text" },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup {}
    end,
  },
}
