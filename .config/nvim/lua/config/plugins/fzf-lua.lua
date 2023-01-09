return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'kyazdani42/nvim-web-devicons',
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
