-- Custom NeoTree plugin to generate Angular components

-- actions used by generate_in_dir
local generate_actions = {
  {
    name = "angular",
    id = 1,
    subselect = {
      { id = 1, name = "component:standalone", value = "component --standalone" },
      { id = 2, name = "component", value = "component" },
      { id = 3, name = "directive", value = "directive" },
      { id = 4, name = "service", value = "service" },
    },
    action = function(_, directory_path, subselect)
      vim.ui.input({ prompt = subselect.name .. " name:" }, function(input)
        if not input or #input == 0 then
          print("No name provided")
        else
          vim.cmd(string.format(':!cd "%s" && ng generate %s %s', directory_path, subselect.value, input))
        end
      end)
    end,
  },
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["g"] = "generate_in_dir",
      },
    },
    commands = {
      generate_in_dir = function(state)
        local node = state.tree:get_node()

        if not node or node.type ~= "file" and node.type ~= "directory" then
          return
        end

        local path = node:get_id()
        local directory_path = path

        if node.type == "file" then
          -- remove file from path
          directory_path = path:match("(.*/)"):sub(1, -2)
        end

        local function format_item(option)
          return option.id .. ": " .. option.name
        end

        local function subselect(choice)
          vim.ui.select(choice.subselect, {
            prompt = "Generate for " .. choice.name,
            kind = "custom",
            format_item = format_item,
          }, function(inner_choice)
            if inner_choice then
              choice.action(path, directory_path, inner_choice)
            end
          end)
        end

        vim.ui.select(generate_actions, {
          prompt = "Generate",
          kind = "custom",
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
