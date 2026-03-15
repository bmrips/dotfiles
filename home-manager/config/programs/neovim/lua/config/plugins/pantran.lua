return {
  'bmrips/pantran.nvim',
  branch = 'deepl-authentication',
  opts = {
    default_engine = 'deepl',
    engines = {
      deepl = {
        default_target = 'EN-GB',
      },
    },
    select = {
      prompt_prefix = '❯ ',
    },
  },
}
