return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>tt',
      '<cmd>Trouble todo toggle<cr>',
      desc = '[T]rouble toggle [t]odo',
    },
    {
      '<leader>tl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = '[T]rouble toggle [l]sp',
    },
    {
      '<leader>td',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[T]rouble toggle [d]iagnostics',
    },
  },
}
