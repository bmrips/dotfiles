local function treesitterWith(config)
  local localDir = vim.env.NVIM_TREESITTER

  local source = localDir
      and {
        dir = localDir,
        name = 'nvim-treesitter',
        pin = true,
      }
    or {
      'nvim-treesitter/nvim-treesitter',
      opts = { ensure_installed = 'all' },
    }

  return vim.tbl_deep_extend('keep', source, config)
end

return {
  treesitterWith {
    event = 'FileType',
    build = ':TSUpdate',
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      matchup = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },
  treesitterWith {
    optional = true,
    dependencies = 'RRethy/nvim-treesitter-endwise',
    opts = {
      endwise = { enable = true },
    },
  },
  treesitterWith {
    optional = true,
    dependencies = {
      { 'windwp/nvim-ts-autotag', config = true },
    },
  },
}
