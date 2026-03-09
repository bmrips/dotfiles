return {
  'kylechui/nvim-surround',
  event = 'VeryLazy',
  init = function()
    vim.g.nvim_surround_no_normal_mappings = true
  end,
}
