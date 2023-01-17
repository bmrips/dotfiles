return {
  'theblob42/drex.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    keybindings = {
      ['n'] = {
        ['<CR>'] = '<C-^>',
        ['o'] = function() -- open a file
          local line = vim.api.nvim_get_current_line()
          local element = require('drex.utils').get_element(line)
          vim.fn.jobstart('xdg-open "' .. element .. '" &', { detach = true })
        end,
        ['L'] = function()
          require('drex').open_directory()
        end,
        ['H'] = function()
          require('drex').open_parent_directory()
        end,
        ['<C-h>'] = '<C-w>h',
        ['<C-l>'] = '<C-w>l',
        ['<C-s>'] = function()
          require('drex').open_file 'sp'
        end,
      },
    },
  },
  config = function(_, opts)
    require('drex.config').configure(opts)

    -- Do not list drex buffers
    local augroup = vim.api.nvim_create_augroup('drex', {})
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      pattern = 'drex',
      desc = 'Do not list drex buffers',
      callback = function()
        vim.opt_local.buflisted = false
      end,
    })
  end,
}
