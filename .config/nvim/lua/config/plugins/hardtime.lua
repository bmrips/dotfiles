return {
  'm4xshen/hardtime.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  opts = {
    disable_mouse = false,
    resetting_keys = {
      ['[ '] = { 'n' },
      ['[e'] = { 'n' },
      ['] '] = { 'n' },
      [']e'] = { 'n' },
      -- ['g<C-J>'] = { 'n' },
      ['ga'] = { 'n' },
      ['gl'] = { 'n' },
      ['gL'] = { 'n' },
      ['go'] = { 'n' },
    },
    restricted_keys = {
      ['h'] = {},
      ['j'] = {},
      ['k'] = {},
      ['l'] = {},
      ['<C-M>'] = {},
      ['<C-N>'] = {},
      ['<C-P>'] = {},
      ['<CR>'] = {},
    },
  },
}
