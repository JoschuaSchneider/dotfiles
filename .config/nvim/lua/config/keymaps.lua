-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

--  code actions
map("n", "<leader>cD", function()
  require("telescope.builtin").diagnostics()
end, { desc = "All diagnostics" })

map("n", "<leader>cnp", function()
  require("null-ls").toggle("prettierd")
end, { desc = "null-ls toggle prettierd" })

-- toggle copilot
map("n", "<leader>cce", function()
  vim.cmd("Copilot enable")
end, { desc = "enable copilot" })

map("n", "<leader>ccd", function()
  vim.cmd("Copilot disable")
end, { desc = "disable copilot" })

-- use jj and jk to exit insert mode
map("i", "jj", "<esc>", { desc = "Enter normal mode" })
map("i", "jk", "<esc>", { desc = "Enter normal mode" })

-- move in insert mode
map("i", "<C-h>", "<C-o>h", { desc = "Move left in insert mode" })
map("i", "<C-j>", "<C-o>j", { desc = "Move down in insert mode" })
map("i", "<C-k>", "<C-o>k", { desc = "Move up in insert mode" })
map("i", "<C-l>", "<C-o>l", { desc = "Move right in insert mode" })

-- TODO: tmux aware split switching
-- map("n", "<C-h>", "<C-U>TmuxNavigateLeft<cr>", { desc = "Navigate pane left (tmux aware)" })
-- map("n", "<C-k>", "<C-U>TmuxNavigateUp<cr>", { desc = "Navigate pane up (tmux aware)" })
-- map("n", "<C-j>", "<C-U>TmuxNavigateDown<cr>", { desc = "Navigate pane down (tmux aware)" })
-- map("n", "<C-l>", "<C-U>TmuxNavigateRight<cr>", { desc = "Navigate pane right (tmux aware)" })

-- overwrite float_term bindings
map("n", "<leader>ft", function()
  Util.float_term(nil, { cwd = Util.get_root(), border = "shadow" })
end, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function()
  Util.float_term(nil, { border = "shadow" })
end, { desc = "Terminal (cwd)" })

-- telescope
-- TODO: Move to plugins/telescope.lua

map("n", "<leader>fd", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(bufnr)
  local directory = buffer_path:match("(.*/)")

  Util.telescope("files", { cwd = directory })()
end, { desc = "Find Files (Buffer dir)" })
