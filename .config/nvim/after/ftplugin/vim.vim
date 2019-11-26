setlocal comments=:\" commentstring=\"\ %s
setlocal formatoptions-=r formatoptions-=o
setlocal include=^\\s*\\%(source\\|runtime\\%)
let &l:path .= &runtimepath
setlocal tabstop=2

let b:undo_ftplugin = '| set comments< commentstring< formatoptions< include< path< tabstop<'
