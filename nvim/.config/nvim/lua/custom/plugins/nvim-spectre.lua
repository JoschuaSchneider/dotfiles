return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>r', '<cmd>Spectre<cr>', desc = '[R]eplace with Spectre' },
  },
}
