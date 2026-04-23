---@module 'lazy.types'
---@type LazyPluginSpec
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    focus = true,
    modes = {
      symbols = {
        focus = true,
      },
    },
  },
}
