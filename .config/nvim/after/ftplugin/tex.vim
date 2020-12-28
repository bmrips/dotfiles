setlocal colorcolumn+=+1
setlocal comments=:% commentstring=%\ %s
setlocal iskeyword-=_
setlocal path+=/home/bmr/.texlive/texmf-config/tex/**
setlocal path+=/home/bmr/.texlive/texmf-var/tex/**
setlocal path+=/usr/share/texmf/tex/**
setlocal suffixesadd=.tex,.sty,.cls,.ltx,.dtx
setlocal textwidth=100
let &l:define .= '\|DeclarePairedDelimiter\%(X\%(PP\)\=\)\=\s*{\=' " From the mathtools package
let &l:define .= '\|\\\%(re\)\=new\%(operator\|field\)\s*{\=' " From my configuration
let &l:include .= '\|\\\%(input\|usepackage\|RequirePackage\|documentclass\|LoadClass\)'

let b:undo_ftplugin .= '| set colorcolumn< comments< commentstring< define< include< iskeyword< '
                    \ .'path< suffixesadd< textwidth<'

let g:tex_fold_enabled = 1 " Enable syntax folding

let b:AutoPairs = extend(g:AutoPairs, { '$':'$' }) " Automatically insert $ in a pair

compiler! tex

if !exists('g:no_plugin_maps') && !exists('g:no_tex_maps')
  function! s:SynctexForward()
    let win_id = system('xdotool getwindowfocus')
    call jobstart(
        \ ['okular', '--unique', expand('%:p:.:r').'.pdf#src:'.line('.').expand('%:p:.')],
        \ {'detach' : 1})
    sleep 500m
    call system('xdotool windowfocus '.win_id)
    call system('xdotool windowraise '.win_id)
  endfunction
  noremap <buffer> <LocalLeader>o <Cmd>call <SID>SynctexForward()<CR>

  function! s:CreateEnvironment()
    let env = input('Environment: ')
    return env !=# '' ? '\begin{'.env."}\n\\end{".env."}\<Up>\<C-o>A\<C-g>u" : ''
  endfunction
  execute 'inoremap <buffer> <expr> '.g:maplocalleader.'e <SID>CreateEnvironment()'

  let b:undo_ftplugin .= '| mapclear <buffer>'
endif

let b:undo_ftplugin .= '| unlet b:AutoPairs'
