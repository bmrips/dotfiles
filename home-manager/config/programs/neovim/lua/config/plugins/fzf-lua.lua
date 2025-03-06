return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'vijaymarupudi/nvim-fzf',
  },
  opts = {
    winopts = {
      preview = {
        flip_columns = 180,
      },
    },
    fzf_colors = {
      ['fg+'] = '3',
      ['bg+'] = '0',
      ['hl+'] = '2',
      ['pointer'] = '1',
      ['marker'] = '5',
      ['gutter'] = '0',
    },
    lsp = {
      code_actions = {
        winopts = { relative = 'cursor' },
      },
    },
  },
}
