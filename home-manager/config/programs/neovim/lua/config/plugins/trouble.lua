return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  dependencies = 'nvim-tree/nvim-web-devicons',
  init = function()
    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
      desc = 'Open the quickfix and location list windows automatically',
      group = vim.api.nvim_create_augroup('qflist_auto-open', { clear = true }),
      callback = function(args)
        local openLocList = args.match:sub(1, 1) == 'l'
        require('trouble.api').open(openLocList and 'loclist' or 'qflist')
      end,
    })
  end,
  opts = {
    focus = true,
    modes = {
      symbols = {
        focus = true,
      },
    },
  },
  specs = {
    'folke/snacks.nvim',
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts or {}, {
        picker = {
          actions = vim.tbl_deep_extend('force', require('trouble.sources.snacks').actions, {
            qflist = 'trouble_open',
          }),
        },
      })
    end,
  },
}
