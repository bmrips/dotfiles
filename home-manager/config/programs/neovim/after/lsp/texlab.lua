return {
  settings = {
    texlab = {
      build = {
        -- Remove the `-pdf` argument to let the build mode be determined by the
        -- latexmk configuration.
        args = { '-interaction=nonstopmode', '-synctex=1', '%f' },
        onSave = true,
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = true,
      },
      forwardSearch = {
        executable = 'sioyek',
        args = {
          '--reuse-window',
          '--execute-command',
          'toggle_synctex',
          '--inverse-search',
          'texlab inverse-search -i "%%1" -l %%2',
          '--forward-search-file',
          '%f',
          '--forward-search-line',
          '%l',
          '%p',
        },
      },
    },
  },
}
