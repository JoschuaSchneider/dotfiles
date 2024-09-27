return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle right reveal_force_cwd<CR>', { desc = 'NeoTree toggle (cwd)' } },
    { '<leader>E', ':Neotree float reveal_force_cwd<CR>', { desc = 'NeoTree float (cwd)' } },
  },
  opts = {
    filesystem = {
      window = {
        position = 'right',
        mappings = {
          ['q'] = 'close_window',
        },
      },
    },
  },
}
