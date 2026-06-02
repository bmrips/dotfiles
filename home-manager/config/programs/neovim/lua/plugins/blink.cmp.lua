---@module 'lazy.types'
---@type LazyPluginSpec[]
return {
  'saghen/blink.cmp',
  event = { 'CmdlineEnter', 'InsertEnter' },
  dependencies = {
    'saghen/blink.lib',
    'rafamadriz/friendly-snippets',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      documentation = { auto_show = true },
      list = {
        selection = { preselect = false },
      },
    },
    keymap = { preset = 'enter' },
    signature = { enabled = true },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        snippets = {
          opts = {
            extended_filetypes = {
              dart = { 'flutter' },
            },
          },
        },
      },
    },
  },

  opts_extend = { 'sources.default' },
}
