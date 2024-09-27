return {
  {
    'dlvandenberg/tree-sitter-angular',
    lazy = true,
    event = { 'FileType' },
    ft = { 'htmlangular' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('set-angular-filetype', { clear = true }),
        pattern = '*.component.html',
        callback = function()
          -- Necessary for angular lsp to get attached.
          vim.cmd [[set filetype=html]]
          vim.cmd [[set filetype=htmlangular]]
        end,
      })
    end,
  },
}
