return {
  'lukas-reineke/virt-column.nvim',
  event = 'VeryLazy',
  opts = {
    char = require('util.tty').if_in_pts '⏐',
  },
}
