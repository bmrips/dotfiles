vim.filetype.add {
  extension = {
    bash = 'bash',
    plymouth = 'dosini',
    xkb = 'xkb',

    -- Systemd
    automount = 'systemd',
    link = 'systemd',
    mount = 'systemd',
    network = 'systemd',
    path = 'systemd',
    scope = 'systemd',
    service = 'systemd',
    slice = 'systemd',
    socket = 'systemd',
    target = 'systemd',
    timer = 'systemd',

    -- TeX
    cls = 'tex',
    dtx = 'tex',
    ltx = 'tex',
    lco = 'tex',
    pgf = 'tex',
  },
  filename = {
    ['Jenkinsfile'] = 'groovy',
  },
  pattern = {
    ['/etc/pacman.d/hooks/.*'] = 'dosini',
    ['/usr/share/X11/xkb/.*'] = 'xkb',
    ['.*ssh/config'] = 'sshconfig',
  },
}
