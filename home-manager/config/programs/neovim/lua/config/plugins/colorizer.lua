return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPre',
  cmd = {
    'ColorizerAttachToBuffer',
    'ColorizerDetachFromBuffer',
    'ColorizerReloadAllBuffers',
    'ColorizerToggle',
  },
  opts = {
    lazy_load = true,
    user_default_options = {
      names = false,
    },
  },
}
