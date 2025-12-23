local ls = require 'luasnip'

local s = ls.snippet
local t = ls.text_node

local M = {}

function M.init()
  local snippet = s('editorconf', {
    t {
      'root = true',
      '',
      '[*]',
      'end_of_line = lf',
      'insert_final_newline = true',
      'charset = utf-8',
      'indent_style = space',
      'indent_size = 2',
    },
  })

  ls.add_snippets('editorconfig', { snippet })
end

return M
