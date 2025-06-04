return {
  settings = {
    haskell = {
      formattingProvider = 'fourmolu',
      ['plugin.rename.config.diff'] = true, -- renaming across modules
    },
  },
}
