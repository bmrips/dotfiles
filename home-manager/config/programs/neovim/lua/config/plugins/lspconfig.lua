return {
  {
    'neovim/nvim-lspconfig',
    event = 'FileType',
    cmd = {
      'LspInfo',
      'LspLog',
      'LspRestart',
      'LspStart',
      'LspStop',
    },
    config = function()
      vim.lsp.enable {
        'bashls',
        'dartls',
        'hls',
        'jdtls',
        'ltex_plus',
        'lua_ls',
        'nil_ls',
        'texlab',
        'yamlls',
      }
    end,
  },
  { 'barreiroleo/ltex_extra.nvim' },
}
