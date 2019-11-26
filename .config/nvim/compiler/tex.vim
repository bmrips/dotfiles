if exists("current_compiler")
  finish
endif
let current_compiler = 'tex'

augroup compiler
  autocmd!
  autocmd QuickFixCmdPre *
      \  let curbuf = bufnr('%')
      \| execute 'bufdo if expand("%:e") =~# "tex\\|sty\\|cls" | update | endif'
      \| execute 'buffer '.curbuf
augroup END

" Do not show the quickfix or location list after compiling (see init.vim)
autocmd! init QuickFixCmdPost

" Choose LuaLaTeX only if there is no Makefile
if !(filereadable('Makefile') || filereadable('makefile'))
  CompilerSet makeprg=lualatex\ --halt-on-error\ --file-line-error\ --synctex=1\ --output-directory=\"%:h\"\ \"%\"
endif

CompilerSet errorformat=%E!\ LaTeX\ %trror:\ %m,
    \%E!\ %m,
    \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
    \%+W%.%#\ at\ lines\ %l--%*\\d,
    \%WLaTeX\ %.%#Warning:\ %m,
    \%Cl.%l\ %m,
    \%+C\ \ %m.,
    \%+C%.%#-%.%#,
    \%+C%.%#[]%.%#,
    \%+C[]%.%#,
    \%+C%.%#%[{}\\]%.%#,
    \%+C<%.%#>%.%#,
    \%C\ \ %m,
    \%-GSee\ the\ LaTeX%m,
    \%-GType\ \ H\ <return>%m,
    \%-G\ ...%.%#,
    \%-G%.%#\ (C)\ %.%#,
    \%-G(see\ the\ transcript%.%#),
    \%-G\\s%#,
    \%+O(%*[^()])%r,
    \%+O%*[^()](%*[^()])%r,
    \%+P(%f%r,
    \%+P\ %\\=(%f%r,
    \%+P%*[^()](%f%r,
    \%+P[%\\d%[^()]%#(%f%r,
    \%+Q)%r,
    \%+Q%*[^()])%r,
    \%+Q[%\\d%*[^()])%r
