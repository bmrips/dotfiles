return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'FileType',
    build = ':TSUpdate',
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      matchup = { enable = true },

      ensure_installed = 'all',

      -- Automatically install missing parsers when entering buffer.
      auto_install = false,
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    optional = true,
    dependencies = 'RRethy/nvim-treesitter-endwise',
    opts = {
      endwise = { enable = true },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    optional = true,
    dependencies = {
      { 'windwp/nvim-ts-autotag', config = true },
    },
  },
}
