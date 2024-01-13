-- rose-pine theme
return {
  {
    "rose-pine/neovim",
    tag = "v1.2.2",
    opts = {
      dim_nc_background = true,
      disable_background = true,
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
