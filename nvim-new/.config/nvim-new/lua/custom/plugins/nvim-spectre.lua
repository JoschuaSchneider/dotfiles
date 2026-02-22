return {
  'nvim-pack/nvim-spectre',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>r', '<cmd>Spectre<cr>', desc = '[R]eplace with Spectre' },
  },
  opts = {
    replace_engine = {
      -- Mac uses the BSD version of sed, which requires an <extension> argument to the -i flag,
      -- otherwise each change results in a backup File with a -E postfix
      ['sed'] = {
        cmd = 'sed',
        args = {
          '-i',
          '',
          '-E',
        },
      },
    },
  },
}
