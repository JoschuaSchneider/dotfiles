return {
  'gbprod/yanky.nvim',
  opts = {
    highlight = {
      on_put = false,
      on_yank = false,
    },
  },
  keys = {
    { 'p', '<Plug>(YankyPutAfter)' },
    { 'P', '<Plug>(YankyPutBefore)' },
    { 'gp', '<Plug>(YankyGPutAfter)' },
    { 'gP', '<Plug>(YankyGPutBefore)' },
    { '<c-p>', '<Plug>(YankyPreviousEntry)' },
    { '<c-n>', '<Plug>(YankyNextEntry)' },
  },
}
