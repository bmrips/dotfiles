return {
  settings = {
    haskell = {
      cabalFormattingProvider = 'cabal-gild',
      formattingProvider = 'fourmolu',
      plugin = {
        rename = {
          config = {
            crossModule = true,
          },
        },
      },
    },
  },
}
