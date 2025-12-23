return {
  'luissimas/telescope-nodescripts.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  -- Only load if package.json exists in the project
  cond = function()
    return vim.fn.filereadable(vim.fn.getcwd() .. '/package.json') == 1
  end,
  keys = {
    {
      '<leader>ce',
      function()
        require('telescope').extensions.nodescripts.run()
      end,
      desc = '[C]ode [E]xecute (npm scripts)',
    },
  },
  config = function()
    -- Load the extension
    -- Note: Extension configuration needs to be added to telescope setup in init.lua
    -- or configured through vim.g variables if the extension supports it
    pcall(require('telescope').load_extension, 'nodescripts')
  end,
}
