setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal iskeyword+='
setlocal softtabstop=-1 shiftwidth=2
setlocal suffixesadd=.hs,.lhs

let b:undo_ftplugin .= '| set iskeyword< shiftwidth< softtabstop< suffixesadd<'

if !exists('g:no_plugin_maps') && !exists('g:no_haskell_maps')
  " Insert a module section
  function! s:ModuleSection(...)
    let name = empty(a:0) ? input("Section name: ") : a:0
    return [repeat('-', &l:textwidth), '-- '.name, '']
  endfunction

  " Insert a module header
  function! s:ModuleHeader(...)
    let name = empty(a:0) ? input("Module: ") : a:0
    let note = empty(a:1) ? input("Note: ")   : a:1
    let desc = 2 < a:0 ? a:3 : input("Description: ")

    return [repeat('-', &l:textwidth),
        \ '-- |',
        \ '-- Module      : '.name,
        \ '-- Note        : '.note,
        \ '--',
        \ '-- '.desc,
        \ '--',
        \ repeat('-', &l:textwidth), '']
  endfunction

  noremap <buffer> <LocalLeader>s <Cmd>call append(line('.'), <SID>ModuleSection())<CR>
  noremap <buffer> <LocalLeader>h <Cmd>call append(0, <SID>ModuleHeader())<CR>

  let b:undo_ftplugin .= ' | mapclear <buffer>'
endif
