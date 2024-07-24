return {
  'RRethy/nvim-treesitter-endwise',
  event = 'VeryLazy',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-treesitter.configs').setup {
      endwise = {
        enable = true,
      },
    }
  end,
}
