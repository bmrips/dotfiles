return {
  'L3MON4D3/LuaSnip',
  build = 'make install_jsregexp', -- for LSP snippet transformations
  dependencies = 'rafamadriz/friendly-snippets',
  config = function(_, opts)
    require('luasnip').setup(opts)
    require('luasnip.loaders.from_vscode').lazy_load()
  end,
}
