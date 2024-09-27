return {
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'
    auto_session.setup {
      auto_restore_enabled = false,
      auto_session_supress_dirs = { '~/', '~/projects', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = '[R]estore session for cwd' })
    keymap.set('n', '<leader>ww', '<cmd>SessionSave<CR>', { desc = '[W]rite session for auto session root dir' })
    keymap.set('n', '<leader>wf', '<cmd>SessionSearch<CR>', { desc = '[F]ind saved sessions' })
  end,
}
