return {
  settings = {
    texlab = {
      -- Build with LuaLaTeX.
      build = {
        args = { '-lualatex', '-interaction=nonstopmode', '-synctex=1', '%f' },
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
