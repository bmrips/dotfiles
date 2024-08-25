local filename = { 'filename', path = 1 }

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      theme = 'gruvbox-material',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
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
    tabline = {
      lualine_a = {
        {
          'tabs',
          max_length = vim.opt.columns:get(),
          mode = 2,
          path = 1,
          show_modified_status = false,
        },
      },
    },
    extensions = {
      'aerial',
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
    vim.opt.showtabline = 1
  end,
}
