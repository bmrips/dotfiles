return {
  {
    'saghen/blink.cmp',
    event = 'VeryLazy',
    dependencies = { 'rafamadriz/friendly-snippets' },
    build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      appearance = { nerd_font_variant = 'mono' },
      cmdline = {
        completion = {
          list = {
            selection = { preselect = false },
          },
        },
      },
      completion = {
        documentation = { auto_show = true },
        list = {
          selection = { preselect = false },
        },
      },
      fuzzy = {
        prebuilt_binaries = { download = false },
      },
      keymap = { preset = 'enter' },
      signature = { enabled = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'moyiz/blink-emoji.nvim' },
    opts = {
      sources = {
        default = { 'emoji' },
        providers = {
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15,
          },
        },
      },
    },
  },
}
