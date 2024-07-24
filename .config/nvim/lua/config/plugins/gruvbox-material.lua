return {
  'sainnhe/gruvbox-material',
  opts = {
    better_performance = 1,
    disable_terminal_colors = 1,
    enable_bold = 1,
    enable_italic = 1,
    foreground = 'mix',
    sign_column_background = 'grey',
  },
  config = function(_, opts)
    require('compat.vimscript.plugin').setup 'gruvbox_material_'(nil, opts)

    vim.api.nvim_create_autocmd('Colorscheme', {
      pattern = 'gruvbox-material',
      desc = 'Colorscheme overrides',
      callback = function()
        vim.api.nvim_set_hl(0, 'QuickFixLine', { link = 'Visual' })
        vim.api.nvim_set_hl(0, 'Search', { link = 'Substitute' })
      end,
    })
  end,
}
