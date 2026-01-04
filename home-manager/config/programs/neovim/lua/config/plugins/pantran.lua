return {
  'potamides/pantran.nvim',
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
