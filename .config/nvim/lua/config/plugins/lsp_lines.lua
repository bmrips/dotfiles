return {
  'Maan2003/lsp_lines.nvim',
  event = 'VeryLazy',
  config = function()
    require('lsp_lines').setup()

    -- Disable virtual lines initially.
    vim.diagnostic.config {
      virtual_lines = false,
    }
  end,
}
