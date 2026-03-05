return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  cmd = {
    'ColorizerAttachToBuffer',
    'ColorizerDetachFromBuffer',
    'ColorizerReloadAllBuffers',
    'ColorizerToggle',
  },
  init = function()
    vim.opt.termguicolors = true
  end,
  opts = {
    lazy_load = true,
    user_default_options = {
      names = false,
    },
  },
}
