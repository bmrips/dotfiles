return {
  'kdheepak/tabline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      modified_italic = false,
      show_filename_only = true,
      show_tabs_only = true,
    },
  },
  config = function(_, opts)
    require('tabline').setup(opts)
    vim.opt.showtabline = 1
  end,
}
