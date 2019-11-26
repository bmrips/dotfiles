setlocal foldmethod=manual
setlocal formatoptions-=r formatoptions-=o " Do not insert the comment leader automatically

let b:undo_ftplugin .= '| set foldmethod< formatoptions<'
