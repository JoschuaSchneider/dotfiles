return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = true,
  ft = { 'dart' },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = true,
  opts = {
    fvm = true,
  },
}
