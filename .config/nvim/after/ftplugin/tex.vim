setlocal colorcolumn+=+1
setlocal comments=:% commentstring=%\ %s
setlocal path+=/home/bmr/.texlive/texmf-config/tex/**
setlocal path+=/home/bmr/.texlive/texmf-var/tex/**
setlocal path+=/usr/share/texmf/tex/**
setlocal suffixesadd=.tex,.sty,.cls
setlocal textwidth=100
let &l:define .= '\|DeclarePairedDelimiter\%(X\%(PP\)\=\)\=\s*{\=' " From the mathtools package
let &l:define .= '\|\\\%(re\)\=new\%(operator\|field\)\s*{\=' " From my configuration
let &l:include .= '\|\\\%(usepackage\|RequirePackage\|documentclass\|LoadClass\)'

let b:undo_ftplugin .= '| set colorcolumn< comments< commentstring< define< include< path<'
                    \ .' suffixesadd< textwidth<'

let g:tex_fold_enabled = 1 " Enable syntax folding

let b:AutoPairs = extend(g:AutoPairs, { '$':'$' }) " Automatically insert $ in a pair

compiler! tex

let b:undo_ftplugin .= '| unlet b:AutoPairs'
