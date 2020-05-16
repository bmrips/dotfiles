setlocal cindent cinoptions+=:0
setlocal comments=s1:/*,mb:*,ex:*/,:// commentstring=//\ %s
setlocal define=^\\s*#\\s*define
setlocal formatoptions-=t
setlocal include=^\\s*#\\s*include
setlocal path=.,,include,$HOME/.local/include,/usr/local/include,/usr/include

let b:undo_ftplugin .= '| set cindent< cinoptions< comments< commentstring< define< formatoptions<'
                    \. ' include< path<'

if !exists('g:no_plugin_maps') && !exists('g:no_c_maps')
  inoreabbrev #i #include
  inoreabbrev #d #define

  let b:undo_ftplugin .= '| abclear <buffer>'
endif
