return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'vijaymarupudi/nvim-fzf',
  },
  opts = {
    lsp = {
      code_actions = {
        winopts = { relative = 'cursor' },
      },
    },
  },
}
