return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require('fff.download').download_or_build_binary()
  end,
  -- if you are using nixos
  -- build = "nix run .#release",
  opts = { -- (optional)
    debug = {
      enabled = false,
      show_scores = true,
    },
    git = {
      status_text_color = true, -- Apply git status colors to filename text (default: false, only sign column)
    },
  },
  keys = {
    {
      'ff', -- try it if you didn't it is a banger keybinding for a picker
      function() require('fff').find_files() end,
      desc = 'FFFind files',
    },
  },
}
