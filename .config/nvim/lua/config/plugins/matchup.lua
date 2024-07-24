return {
  'andymass/vim-matchup',
  event = {
    'BufNew',
    'BufNewFile',
    'BufReadPost',
  },
  opts = {
    -- Do not display off-screen matches
    matchparen_offscreen = { method = 'status_manual' },

    -- Defer highlighting to improve performance
    matchparen_deferred = 1,
    transmute_enabled = 1,
  },
  config = require('compat.vimscript.plugin').setup 'matchup_',
}
