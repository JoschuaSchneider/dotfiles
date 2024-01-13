return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "elgiano/nvim-treesitter-angular", branch = "topic/jsx-fix", enabled = false },
    },
    ---@type TSConfig
    opts = {
      ensure_installed = {
        "php",
        "c_sharp",
        "graphql",
      },
      indent = {
        enable = true,
      },
    },
  },
}
