return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('ts_context_commentstring').setup {
      enable_autocmd = false,
      languages = {
        vue = {
          __default = '<!-- %s -->',
          css = '/* %s */',
          scss = '/* %s */',
          javascript = '// %s',
          typescript = '// %s',
        },
      },
    }

    -- Configure commentstring for Vue files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'vue',
      callback = function()
        vim.bo.commentstring = '<!-- %s -->'
        -- Enable context-aware commenting
        vim.g.skip_ts_context_commentstring_module = true
      end,
    })

    -- Hook into Comment.nvim if available
    local ok, comment = pcall(require, 'Comment')
    if ok then
      comment.setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end
  end,
}