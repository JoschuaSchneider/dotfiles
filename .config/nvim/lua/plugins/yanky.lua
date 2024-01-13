return {
  "gbprod/yanky.nvim",
  dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
  opts = {
    highlight = { timer = 50 },
    ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
  },
  keys = {
      -- stylua: ignore
    { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
    { "<C-n>", "<Plug>(YankyCycleForward)", mode = { "n", "x" }, desc = "Cycle forward through yank history" },
    { "<C-p>", "<Plug>(YankyCycleBackward)", mode = { "n", "x" }, desc = "Cycle backward through yank history" },
  },
}
