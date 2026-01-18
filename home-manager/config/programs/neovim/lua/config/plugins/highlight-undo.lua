return {
  'tzachar/highlight-undo.nvim',
  keys = { { 'u' }, { '<C-r>' } },
  config = function()
    require('highlight-undo').setup()

    local setHlGroup = function()
      vim.api.nvim_set_hl(0, 'HighlightRedo', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'HighlightUndo', { link = 'Visual' })
    end

    setHlGroup()

    vim.api.nvim_create_autocmd('Colorscheme', {
      desc = 'Undo highlighting overrides',
      group = vim.api.nvim_create_augroup('highlight-undo', { clear = true }),
      callback = setHlGroup,
    })
  end,
}
