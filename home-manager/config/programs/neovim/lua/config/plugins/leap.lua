return {
  url = 'https://codeberg.org/andyg/leap.nvim.git',
  dependencies = 'tpope/vim-repeat',
  config = function()
    local opts = require('leap').opts
    opts.case_sensitive = true
  end,
}
