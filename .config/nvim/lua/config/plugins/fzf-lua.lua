return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'vijaymarupudi/nvim-fzf',
  },
  opts = {
    winopts = {
      preview = {
        flip_columns = 150,
      },
    },
    lsp = {
      code_actions = {
        winopts = { relative = 'cursor' },
      },
    },
  },
}
