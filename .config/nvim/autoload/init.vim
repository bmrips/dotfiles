" Create a fold for line1..line2 at the given level
function! init#fold(level) range
  let [start,end] = a:firstline<a:lastline ? [a:firstline,a:lastline] : [a:lastline,a:firstline]
  let [fdr_start, fdr_end] = split(&l:foldmarker, ',')
  let level = a:level==0 ? '' : a:level
  call setline(start, init#foldmark(getline(start), fdr_start, level))
  if start != end
    call setline(end, init#foldmark(getline(end), fdr_end, level))
  endif
endfunction

" Create a fold mark
function! init#foldmark(line, marker, level)
  if empty(a:line)
    let line = &l:commentstring
  else
    let line = substitute(a:line, '\s*$', ' '.&l:commentstring, '')
  endif
  return substitute(line, '%s', a:marker.a:level, '')
endfunction

" Reindent from the old to the new shiftwidth
function! init#reindent(old, new) range
  let view = winsaveview()
  execute 'keeppatterns keepjumps '.a:firstline.','.a:lastline.'s@\v^(\s*)@'
        \.'\=repeat(" ", strdisplaywidth(submatch(1)) / '.a:old.' * '.a:new.')@'
  call winrestview(view)
endfunction
