" moreverb.vim
" Author:  Charles E. Campbell
" Date:    Aug 20, 2013
" Version: 1a ASTRO-ONLY
"
" Support for the moreverb package

" Save compatibility options and reset them to Vim default to enable line continuation
let s:save_cpo = &cpoptions
set cpoptions&vim

let b:loaded_moreverb = "v1a"
if exists("g:tex_verbspell")
	syntax region texZone start="\\begin{verbatimtab}"    end="\\end{verbatimtab}\|%stopzone\>"   contains=@Spell
	syntax region texZone start="\\begin{verbatimwrite}"  end="\\end{verbatimwrite}\|%stopzone\>" contains=@Spell
	syntax region texZone start="\\begin{boxedverbatim}"  end="\\end{boxedverbatim}\|%stopzone\>" contains=@Spell
else
	syntax region texZone start="\\begin{verbatimtab}"    end="\\end{verbatimtab}\|%stopzone\>"
	syntax region texZone start="\\begin{verbatimwrite}"  end="\\end{verbatimwrite}\|%stopzone\>"
	syntax region texZone start="\\begin{boxedverbatim}"  end="\\end{boxedverbatim}\|%stopzone\>"
endif

" Restore compatibility options
let &cpoptions = s:save_cpo
unlet s:save_cpo
