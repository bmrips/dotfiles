return {
  -- use fork of 'anuvyklack/pretty-fold.nvim' until
  -- https://github.com/anuvyklack/pretty-fold.nvim/issues/39 is merged
  'bbjornstad/pretty-fold.nvim',
  event = 'VeryLazy',
  opts = {
    fill_char = ' ',
  },
}
