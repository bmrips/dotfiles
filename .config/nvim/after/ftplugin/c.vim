setlocal cindent cinoptions+=:0
setlocal comments=s1:/*,mb:*,ex:*/,:// commentstring=//\ %s
setlocal define=^\\s*#\\s*define
setlocal formatoptions-=t
setlocal include=^\\s*#\\s*include
setlocal path=.,,include,$HOME/.local/include,/usr/local/include,/usr/include

let b:undo_ftplugin .= '| set cindent< cinoptions< comments< commentstring< define< formatoptions<'
                    \. ' include< path<'

if !exists('g:no_plugin_maps') && !exists('g:no_c_maps')
  " Add #include guard
  function! s:IncludeGuard()
    let name = '_' . substitute(toupper(expand('%:t:r')), '\U', '_', 'g') . '_H'
    return '#ifndef ' . name . "\n" . '#define ' . name . "\n\n\n\n#endif"
  endfunction

  " Abbreviations
  inoreabbrev #i #include
  inoreabbrev #d #define
  inoreabbrev #g <C-r>=<SID>IncludeGuard()<CR><Esc>2ki

  let b:undo_ftplugin .= '| abclear <buffer>'
endif
