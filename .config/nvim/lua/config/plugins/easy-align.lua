return {
  'junegunn/vim-easy-align',
  keys = { '<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)' },
  cmd = { 'EasyAlgin', 'LiveEasyAlign' },
  opts = {
    delimiters = {
      ['>'] = {
        pattern = [[->\|-->\|=>\|==>\|\~>\|\~\~>]],
      },
    },
  },
  config = require('compat.vimscript.plugin').setup 'easy_align_',
}
