return {
  settings = {
    haskell = {
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
