return {
  "windwp/nvim-ts-autotag",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-ts-autotag").setup({
      enable_rename = false,
    })
  end,
}
