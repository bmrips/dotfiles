return {
  'ggandor/leap.nvim',
  dependencies = 'tpope/vim-repeat',
  config = function()
    local opts = require('leap').opts
    opts.case_sensitive = true
  end,
}
