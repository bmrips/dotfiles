local filename = { 'filename', path = 1 }

return {
  'nvim-lualine/lualine.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      theme = 'gruvbox-material',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_b = { 'diagnostics' },
      lualine_c = { filename },
      lualine_x = {
        'filetype',
        {
          'fileformat',
          icons_enabled = true,
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
      'drex',
      'fzf',
      'man',
      'mundo',
      'quickfix',
    },
  },
  config = function(_, opts)
    require('lualine').setup(opts)
    vim.opt.showmode = false
  end,
}
