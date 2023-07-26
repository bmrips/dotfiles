vim.filetype.add {
  extension = {
    bash = 'bash',
    plymouth = 'dosini',
    xkb = 'xkb',

    -- TeX
    cls = 'tex',
    dtx = 'tex',
    ltx = 'tex',
    lco = 'tex',
    pgf = 'tex',
  },
  pattern = {
    Jenkinsfile = 'groovy',
    ['/etc/pacman.d/hooks/*'] = 'dosini',
    ['/usr/share/X11/xkb/*'] = 'xkb',
  },
}
