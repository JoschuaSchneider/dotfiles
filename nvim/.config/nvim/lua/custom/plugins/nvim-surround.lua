return {
  'kylechui/nvim-surround',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  version = '*',
  event = { 'BufRead', 'BufNewFile' },
  config = function()
    require('nvim-surround').setup {}
  end,
}
