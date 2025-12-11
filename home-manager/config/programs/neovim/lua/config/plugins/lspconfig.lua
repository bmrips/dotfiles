return {
  'neovim/nvim-lspconfig',
  event = 'FileType',
  dependencies = 'barreiroleo/ltex_extra.nvim',
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
      'clangd',
      'dartls',
      'emmylua_ls',
      'harper_ls',
      'hls',
      'jdtls',
      'ltex_plus',
      'nil_ls',
      'texlab',
      'yamlls',
    }
  end,
}
