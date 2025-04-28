return {
  'potamides/pantran.nvim',
  opts = {
    default_engine = 'deepl',
    engines = {
      deepl = {
        default_target = 'EN-GB',
        auth_key = vim.env.DEEPL_API_TOKEN,
      },
    },
    select = {
      prompt_prefix = '❯ ',
    },
  },
}
