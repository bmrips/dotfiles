return {
  'jiangmiao/auto-pairs',
  opts = {
    -- Do not create the <M-n> shortcut to map it myself later.
    ShortcutJump = '',
  },
  config = require('compat.vimscript.plugin').setup 'AutoPairs',
}
