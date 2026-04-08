return {
  {
    'saghen/blink.cmp',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'rafamadriz/friendly-snippets',
    build = 'nix run .#build-plugin',

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
      fuzzy = {
        prebuilt_binaries = { download = false },
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
  },
  {
    'saghen/blink.cmp',
    optional = true,
    dependencies = 'moyiz/blink-emoji.nvim',
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
