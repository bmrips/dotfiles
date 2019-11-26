setlocal comments=:# commentstring=#\ %s
setlocal formatoptions-=t formatoptions+=l

let b:undo_ftplugin .= '| set comments< commentstring< formatoptions<'
