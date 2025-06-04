return {
  on_attach = function()
    require('ltex_extra').setup {
      load_langs = { 'en-GB', 'de-DE' },
      path = '.ltex',
    }
  end,
  settings = {
    ltex = {
      language = 'en-GB',
      ['additionalRules.enablePickyRules'] = true,
      completionEnabled = true,
    },
  },
}
