setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal iskeyword+='
setlocal softtabstop=-1 shiftwidth=2
setlocal suffixesadd=.hs,.lhs

let b:undo_ftplugin .= '| set iskeyword< shiftwidth< softtabstop< suffixesadd<'
