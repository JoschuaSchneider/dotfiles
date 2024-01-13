return {
  -- disable mini.indentscope animations
  {
    "echasnovski/mini.indentscope",
    opts = function()
      return {
        draw = {
          animation = require("mini.indentscope").gen_animation.none(),
        },
      }
    end,
  },
  -- setup custom indent-blankline colors
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        highlight = {
          "IndentBlanklineIndent1",
        },
      },
    },
  },
}
