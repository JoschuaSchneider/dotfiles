vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_WindowLayout = 2

return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  keys = {
    { '<leader>u', ':UndotreeToggle<CR>', { desc = 'Undotree toggle' } },
  },
  opts = {},
}
