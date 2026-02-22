return {
  'axelvc/template-string.nvim',
  ft = {
    'typescript',
    'typescriptreact',
  },
  config = function() require('template-string').setup {} end,
}
