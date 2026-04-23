---@module 'lazy.types'
---@type LazyPluginSpec
return {
  'akinsho/git-conflict.nvim',
  event = 'BufReadPost',
  opts = {
    highlights = {
      current = 'DiffChange',
    },
  },
}
