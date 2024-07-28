return {
  'nvim-treesitter/nvim-treesitter',
  event = 'FileType',
  build = ':TSUpdate',
  opts = {
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gyi',
        node_decremental = 'gy[',
        node_incremental = 'gy]',
        scope_incremental = 'gys',
      },
    },
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
}
