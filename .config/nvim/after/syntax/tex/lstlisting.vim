" lstlisting.vim
" Author:  Charles E. Campbell
" Date:    Sep 09, 2018
" Version: 1c ASTRO-ONLY

" Support for the lstlisting LaTeX package
" NOTE: If s:tex_fast contains "v" AND g:tex_verbspell exists, then the lstlisting texZone will
" permit spellchecking there.

let b:loaded_lstlisting  = "v1c"

" Save compatibility options and reset them to Vim default to enable line continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

syntax region texZone  start="\\lstinputlisting"   end="{\s*[a-zA-Z/.0-9_^]\+\s*}"

" By default, enable all region-based highlighting
let s:tex_fast= "bcmMprsSvV"
if exists("g:tex_fast")
	if type(g:tex_fast) != 1
		" g:tex_fast exists and is not a string, so
		" turn off all optional region-based highighting
		let s:tex_fast= ""
	else
		let s:tex_fast= g:tex_fast
	endif
endif

if s:tex_fast =~# 'v'
	if exists("g:tex_verbspell") && g:tex_verbspell
		syntax region texZone matchgroup=texBeginEnd start="\\begin{lstlisting}" matchgroup=texBeginEnd end="\\end{lstlisting}\|%stopzone\>" contains=@Spell
	else
		syntax region texZone matchgroup=texBeginEnd start="\\begin{lstlisting}" matchgroup=texBeginEnd end="\\end{lstlisting}\|%stopzone\>"
	endif
else
	syntax region texZone matchgroup=texBeginEnd start="\\begin{lstlisting}" matchgroup=texBeginEnd end="\\end{lstlisting}\|%stopzone\>"
endif

" Restore compatibility options
let &cpoptions = s:save_cpo
unlet s:save_cpo
