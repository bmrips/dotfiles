return {
  'iamcco/markdown-preview.nvim',
  build = 'env --chdir app npm install',
  ft = 'markdown',
  opts = {
    -- Do not close the current preview when changing the buffer.
    auto_close = 0,
  },
  config = require('compat.vimscript.plugin').setup 'mkdp_',
}
