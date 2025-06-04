return {
  on_attach = function()
    -- Defer the ltex_extra setup to ensure that ltex-ls is online.
    vim.defer_fn(function()
      require('ltex_extra').setup {
        load_langs = { 'en-GB', 'de-DE' },
        path = '.ltex',
      }
    end, 1000)
  end,
  settings = {
    ltex = {
      language = 'en-GB',
      ['additionalRules.enablePickyRules'] = true,
      completionEnabled = true,
    },
  },
}
