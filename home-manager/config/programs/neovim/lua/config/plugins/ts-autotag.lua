---@module 'lazy.types'
---@type LazyPluginSpec
return {
  'windwp/nvim-ts-autotag',
  dependencies = 'nvim-treesitter',
  event = 'VeryLazy',
  config = true,
}
