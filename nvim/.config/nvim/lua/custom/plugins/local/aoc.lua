local M = {}

local function get_current_year()
  return os.date '%Y'
end

local function get_current_day()
  return os.date '%d'
end

-- -- Function to setup harpoon marks for AOC files
-- local function setup_aoc_harpoon()
--   local harpoon = require 'harpoon'
--   local year = get_current_year()
--   local day = get_current_day()
--
--   -- Clear existing marks
--   harpoon:list():clear()
--
--   local base = '/Users/joschua/projects/personal/aoc2024/python'
--
--   -- Add new marks for AOC files
--   local files = {
--     string.format('%s/test/%s/%s/part-1.py', base, year, day),
--     string.format('%s/test/%s/%s/part-2.py', base, year, day),
--     string.format('%s/test/%s/%s/test-input', base, year, day),
--     string.format('%s/test/%s/%s/input', base, year, day),
--   }
--
--   local list = harpoon:list()
--
--   list:clear()
--
--     for _, file in ipairs(files) do
--         -- Create file if it doesn't exist
--         if vim.fn.filereadable(file) == 0 then
--             local f = io.open(file, "w")
--             if f then
--                 f:close()
--             end
--         end
--         list:add(file)
--     end
-- end

-- Function to get the current buffer's file path
local function get_current_buffer_path()
  return vim.fn.expand '%:p:h'
end

-- Function to get the current buffer's name
local function get_current_buffer_name()
  return vim.fn.expand '%:t'
end

-- Function to create or get the output buffer
local function get_output_buffer()
  local bufnr = vim.fn.bufnr 'RunOutput'
  if bufnr == -1 then
    -- Create a new buffer if it doesn't exist
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, 'RunOutput')
  end
  return bufnr
end

-- Function to check if a buffer is visible in any window
local function is_buffer_visible(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return true, win
    end
  end
  return false, nil
end

-- Function to execute the command and handle output
local function execute_command(cmd)
  -- Save the current buffer first
  vim.cmd 'write'

  -- Create a temporary file for output
  local output_bufnr = get_output_buffer()

  -- Execute the command and capture output
  local handle = io.popen(cmd .. ' 2>&1')
  if handle then
    local result = handle:read '*a'
    handle:close()

    -- Clear the buffer and set its content
    vim.api.nvim_buf_set_option(output_bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, vim.split(result, '\n'))

    -- Check if the buffer is already visible
    local is_visible, win = is_buffer_visible(output_bufnr)

    if is_visible and win then
      -- If visible, just focus the window
      vim.api.nvim_set_current_win(win)
    else
      -- If not visible, create a new split
      vim.cmd 'vsplit'
      vim.api.nvim_win_set_buf(0, output_bufnr)
    end
  end
end

-- Main function to show selection and execute command
function M.run_buffer()
  local current_path = get_current_buffer_path()
  local current_file = get_current_buffer_name()

  vim.ui.select({ '1: run:test', '2: run' }, {
    prompt = 'Select AOC run mode:',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    if choice and string.match(choice, '^1') then
      local cmd = string.format('python3 %s/%s < %s/test-input', current_path, current_file, current_path)
      execute_command(cmd)
    elseif choice and string.match(choice, '^2') then
      local cmd = string.format('python3 %s/%s < %s/input', current_path, current_file, current_path)
      execute_command(cmd)
    end
  end)
end

-- Set up the keybinding
function M.setup(opts)
  -- Default keybinding is <leader>r, but can be configured
  local keybind = (opts and opts.keybind) or '<leader>r'

  vim.keymap.set('n', keybind, M.run_buffer, {
    noremap = true,
    silent = true,
    desc = 'Run buffer with input',
  })

  -- vim.api.nvim_create_user_command('Aoch', function()
  --   setup_aoc_harpoon()
  --   print 'Harpoon marks updated for AOC files'
  -- end, {})
end

return M
