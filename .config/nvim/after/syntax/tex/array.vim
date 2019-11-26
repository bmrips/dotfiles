" array.vim
" Author:  Karl Yngve Leråg <karl.yngve@gmail.com>
" Date:    May 16, 2017
" Version: 1a
"
" Support for the array LaTeX package

let b:loaded_array = "v1a"

" Save compatibility options and reset them to Vim default to enable line continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

if get(g:, 'tex_fast', 'M') =~# 'M'
	syntax clear texMathZoneX
	if &encoding ==# 'utf-8' && get(g:, 'tex_conceal', 'd') =~# 'd'
		syntax region texMathZoneX matchgroup=Delimiter start="\([<>]{\)\@<!\$" skip="\%(\\\\\)*\\\$" matchgroup=Delimiter end="\$" end="%stopzone\>" concealends contains=@texMathZoneGroup
	else
		syntax region texMathZoneX matchgroup=Delimiter start="\([<>]{\)\@<!\$" skip="\%(\\\\\)*\\\$" matchgroup=Delimiter end="\$" end="%stopzone\>" contains=@texMathZoneGroup
	endif
endif

" Restore compatibility options
let &cpoptions = s:save_cpo
unlet s:save_cpo
