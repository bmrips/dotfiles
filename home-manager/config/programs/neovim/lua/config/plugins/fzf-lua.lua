return {
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'vijaymarupudi/nvim-fzf',
  },
  opts = function()
    local actions = require('fzf-lua').actions
    return {
      actions = {
        files = {
          true,
          ['ctrl-c'] = actions.file_sel_to_qf,
          ['ctrl-l'] = actions.file_sel_to_ll,
        },
      },
      fzf_colors = {
        ['gutter'] = '0',
      },
      keymap = {
        builtin = {
          true,
          ['<M-j>'] = 'preview-half-page-down',
          ['<M-k>'] = 'preview-half-page-up',
          ['<M-C-j>'] = 'preview-down',
          ['<M-C-k>'] = 'preview-up',
          ['<M-m>'] = 'toggle-fullscreen',
          ['<M-p>'] = 'toggle-preview',
          ['<M-[>'] = 'toggle-preview-ccw',
          ['<M-]>'] = 'toggle-preview-cw',
        },
        fzf = {
          true,
          ['ctrl-a'] = 'toggle-all',
          ['ctrl-e'] = nil,
        },
      },
      lsp = {
        code_actions = {
          winopts = { relative = 'cursor' },
        },
      },
      winopts = {
        preview = {
          flip_columns = 180,
        },
      },
    }
  end,
}
