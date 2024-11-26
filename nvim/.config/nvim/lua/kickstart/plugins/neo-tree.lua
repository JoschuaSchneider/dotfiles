local default_options = '--skip-tests'

local angular_action = function(_, directory_path, subselect, refresh)
  vim.ui.input({ prompt = subselect.name .. ' name:' }, function(input)
    if not input or #input == 0 then
      print 'No name provided'
    else
      vim.cmd(string.format(':!cd "%s" && ng generate %s %s %s', directory_path, subselect.value, default_options, input))
      refresh()
    end
  end)
end

local generate_actions = {
  {
    name = 'angular',
    id = 1,
    subselect = {
      { id = 1, name = 'component:standalone', value = 'component --standalone' },
      { id = 1, name = 'component:standalone:inline-template', value = 'component --standalone --inline-template' },
      { id = 1, name = 'component:standalone:inline-template:nostyle', value = 'component --standalone --inline-template --style=none' },
      { id = 3, name = 'directive:standalone', value = 'directive --standalone' },
      { id = 3, name = 'guard:functional', value = 'guard --functional' },
      { id = 3, name = 'guard', value = 'guard' },
      { id = 4, name = 'service', value = 'service' },
    },
    action = angular_action,
  },
}

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle right reveal_force_cwd<CR>', { desc = 'NeoTree toggle (cwd)' } },
    { '<leader>E', ':Neotree float reveal_force_cwd<CR>', { desc = 'NeoTree float (cwd)' } },
  },
  opts = {
    filesystem = {
      window = {
        position = 'right',
        mappings = {
          ['q'] = 'close_window',
        },
      },
    },
    window = {
      mappings = {
        ['g'] = 'generate_in_dir',
      },
    },
    commands = {
      generate_in_dir = function(state)
        local node = state.tree:get_node()

        local refresh = function()
          local fs_state = require('neo-tree.sources.manager').get_state 'filesystem'
          require('neo-tree.sources.filesystem.commands').refresh(fs_state)
        end

        if not node or node.type ~= 'file' and node.type ~= 'directory' then
          return
        end

        local path = node:get_id()
        local directory_path = path

        if node.type == 'file' then
          -- remove file from path
          directory_path = path:match('(.*/)'):sub(1, -2)
        end

        local function format_item(option)
          return option.id .. ': ' .. option.name
        end

        local function subselect(choice)
          vim.ui.select(choice.subselect, {
            prompt = 'Generate for ' .. choice.name,
            kind = 'custom',
            format_item = format_item,
          }, function(inner_choice)
            if inner_choice then
              choice.action(path, directory_path, inner_choice, refresh)
            end
          end)
        end

        vim.ui.select(generate_actions, {
          prompt = 'Generate',
          kind = 'custom',
          format_item = format_item,
        }, function(choice)
          if choice and choice.subselect then
            subselect(choice)
          elseif choice and choice.action then
            choice.action(path, directory_path)
          end
        end)
      end,
    },
  },
}
