return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = true,
  opts = {
    fvm = true,
    debugger = {
      enabled = true,
    },
  },
}
