return {
  'sQVe/sort.nvim',
  config = function()
    require('sort').setup()
    vim.cmd.cnoreabbrev { 'sort', 'Sort' }
  end,
}
