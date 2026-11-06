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
      additionalRules = {
        enablePickyRules = true,
      },
      completionEnabled = true,
      language = 'en-GB',
      languageToolHttpServerUri = 'http://localhost:8081',
      latex = {
        commands = {
          -- https://github.com/ltex-plus/ltex-ls-plus/pull/224/changes
          ['\\footref{}'] = 'ignore',
          -- https://github.com/ltex-plus/ltex-ls-plus/pull/225
          ['\\slash{}'] = 'dummy',
        },
      },
    },
  },
}
