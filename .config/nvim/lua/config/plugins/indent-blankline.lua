return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  opts = {
    indent = {
      char = '⏐',
    },
    exclude = {
      filetypes = {
        'help',
        'markdown',
      },
    },
  },
  config = function(_, opts)
    require('ibl').setup(opts)
  end,
}
