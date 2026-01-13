return {
  url = 'https://codeberg.org/andyg/leap.nvim.git',
  dependencies = 'tpope/vim-repeat',
  config = function()
    require('leap').opts.case_sensitive = true
  end,
}
