return {
  "mfussenegger/nvim-dap",
  enabled = false,
  config = function()
    require("dap.ext.vscode").load_launchjs()
  end,
}
