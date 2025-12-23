return {
  'christoomey/vim-tmux-navigator',
  enabled = false,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  keys = {
    { '<c-w>h', '<cmd>TmuxNavigateLeft<cr>' },
    { '<c-w>j', '<cmd>TmuxNavigateDown<cr>' },
    { '<c-w>k', '<cmd>TmuxNavigateUp<cr>' },
    { '<c-w>l', '<cmd>TmuxNavigateRight<cr>' },
  },
}
