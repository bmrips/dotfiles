local tty = require 'util.tty'

return {
  'ibhagwan/fzf-lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'vijaymarupudi/nvim-fzf',
  },
  opts = {
    winopts = {
      preview = {
        flip_columns = 150,
      },
    },
    files = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    git = {
      files = {
        file_icons = tty.is_a_pts,
        git_icons = tty.is_a_pts,
      },
      status = {
        file_icons = tty.is_a_pts,
        git_icons = tty.is_a_pts,
      },
    },
    grep = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    buffers = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    tabs = {
      file_icons = tty.is_a_pts,
    },
    tags = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    btags = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    quickfix = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    lsp = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
      code_actions = {
        winopts = { relative = 'cursor' },
      },
    },
    diagnostics = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
    complete_file = {
      file_icons = tty.is_a_pts,
      git_icons = tty.is_a_pts,
    },
  },
}
