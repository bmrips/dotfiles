return {
  'lukas-reineke/indent-blankline.nvim',
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
}
