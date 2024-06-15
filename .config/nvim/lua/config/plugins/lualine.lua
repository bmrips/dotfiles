local tty = require 'util.tty'

local filename = { 'filename', path = 1 }

return {
  'nvim-lualine/lualine.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      theme = 'gruvbox-material',
      component_separators = tty.if_in_pts { left = '', right = '' } or '|',
      section_separators = tty.if_in_pts { left = '', right = '' } or '',
    },
    sections = {
      lualine_b = { 'diagnostics' },
      lualine_c = { filename },
      lualine_x = {
        'searchcount',
        'filetype',
        {
          'fileformat',
          symbols = {
            unix = 'LF',
            dos = 'CRlF',
            mac = 'CR',
          },
        },
      },
    },
    inactive_sections = {
      lualine_c = { filename },
    },
    extensions = {
      'fzf',
      'lazy',
      'man',
      'mundo',
      'quickfix',
      'trouble',
    },
  },
  config = function(_, opts)
    require('lualine').setup(opts)
    vim.opt.showmode = false
  end,
}
