return {
  'rcarriga/nvim-notify',
  init = function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(...)
      require('lazy').load { plugins = { 'nvim-notify' } }
      return vim.notify(...)
    end
  end,
  cmd = 'Notifications',
  opts = {
    render = 'compact',
    stages = 'fade',
  },
  config = function(_, opts)
    local notify = require 'notify'
    notify.setup(opts)
    vim.notify = notify
  end,
}
