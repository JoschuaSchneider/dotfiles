return {
  'wojciech-kulik/xcodebuild.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim', -- (optional) to show previews
  },
  config = function()
    require('xcodebuild').setup {}
  end,
}
