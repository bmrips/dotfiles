setlocal makeprg=latexmk\ \"%\"

autocmd QuickFixCmdPre *
    \  let curbuf = bufnr('%')
    \| execute 'bufdo if expand("%:e") =~# "tex\\|sty\\|cls\\|bib" | update | endif'
    \| execute 'buffer '.curbuf
