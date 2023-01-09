return {
  'junegunn/vim-easy-align',
  opts = {
    delimiters = {
      ['>'] = {
        pattern = '->\\|-->\\|=>\\|==>\\|\\~>\\|\\~\\~>',
      },
    },
  },
  config = require('compat.vimscript.plugin').setup 'easy_align_',
}
