return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  opts = {
    indent = {
      char = require('util.tty').if_in_pts '⏐',
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
