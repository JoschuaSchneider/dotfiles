return {
  'epwalsh/obsidian.nvim',
  version = '*',
  ft = 'markdown',
  -- event = {
  --   'BufReadPre ~/.obsidian/nvault/*.md',
  --   'BufNewFile ~/.obsidian/nvault/*.md',
  -- },
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'nvault',
        path = '~/.obsidian/nvault',
      },
    },
  },
  config = function(opts)
    local obsidian = require 'obsidian'
    obsidian.setup(opts)

    vim.keymap.set('n', '<leader>od', '<cmd>ObsidianDailies<CR>', { desc = '[O]bsidian [d]aylies' })
    vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<CR>', { desc = '[O]bsidian [t]oday' })
    vim.keymap.set('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', { desc = '[O]bsidian [o]pen' })
    vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', { desc = '[O]bsidian [n]ew' })
    vim.keymap.set('n', '<leader>of', '<cmd>ObsidianFollowLink<CR>', { desc = '[O]bsidian [F]ollow Link' })
    vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<CR>', { desc = '[O]bsidian [S]earch' })
    vim.keymap.set({ 'n', 'v' }, '<leader>ol', '<cmd>ObsidianLinkNew<CR>', { desc = '[O]bsidian [L]ink New' })
    vim.keymap.set({ 'n', 'v' }, '<leader>oc', '<cmd>ObsidianToggleCheckbox<CR>', { desc = '[O]bsidian toggle [c]heckbox' })
  end,
}
