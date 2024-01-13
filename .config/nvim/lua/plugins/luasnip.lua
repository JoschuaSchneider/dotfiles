return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip.loaders.from_vscode").load()
    require("luasnip.loaders.from_vscode").load({
      paths = { "~/.config/nvim_lazy/lua/snippets" },
    })
    require("luasnip").filetype_extend("typescript", { "angular" })
    require("luasnip").filetype_extend("html", { "angular" })
    require("luasnip").filetype_extend("typescriptreact", { "typescriptreact" })
  end,
}
