return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    }, -- TODO
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
    },
    input = {
      enabled = true,
    },
    lazygit = {
      configure = false,
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    picker = {
      enabled = true,
      layout = {
        cycle = false,
        preset = function()
          return vim.o.columns >= 180 and 'default' or 'vertical'
        end,
      },
      win = {
        input = {
          keys = {
            ['<C-c>'] = { 'qflist', mode = { 'i', 'n' } },
            ['<C-l>'] = { 'loclist', mode = { 'i', 'n' } },
            ['<C-q>'] = { 'close', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = {
            ['<C-c>'] = 'qflist',
            ['<C-l>'] = 'loclist',
            ['<C-q>'] = 'close',
          },
        },
        preview = {
          keys = {
            ['<C-q>'] = 'close',
          },
        },
      },
    },
    quickfile = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
    styles = {
      input = {
        relative = 'cursor',
        row = -3,
        col = 0,
        keys = {
          ctrl_q = { '<C-q>', { 'cmp_close', 'cancel' }, mode = { 'i', 'n' }, expr = true },
        },
      },
    },
    words = {
      enabled = true,
    },
  },
}

-- TODO: bindings for
--  * lazygit
--  * git
--  * gitbrowse
--  * dim
