return {
  'lukas-reineke/indent-blankline.nvim',
  opts = {
    char = require('util.tty').if_in_pts '⏐',
    filetype_exclude = {
      'help',
      'markdown',
    },
    show_current_context = true,
    use_treesitter = true,
  },
}
