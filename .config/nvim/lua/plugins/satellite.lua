return {
  "lewis6991/satellite.nvim",
  opts = {
    excluded_filetypes = {
      "neo-tree",
    },
  },
  config = function(_, opts)
    require("satellite").setup(opts)
  end,
}
