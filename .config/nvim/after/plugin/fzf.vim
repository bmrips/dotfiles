let g:fzf_action = {
  \ 'ctrl-p': 'pedit',
  \ 'ctrl-r': 'read',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-x': 'split',
  \}

command! -bar -nargs=? -complete=dir Files
    \ call fzf#run(fzf#wrap())

function! s:Buffers()
  return sort(map(
      \ filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "qf"'),
      \ 'bufname(v:val)'))
endfunction

command! -bar -nargs=? -complete=buffer Buffers
    \ call fzf#run(fzf#wrap({ 'source': s:Buffers() }))

function! s:GrepSink(lines)
  let [key, line] = a:lines
  let cmd = get(g:fzf_action, key, 'edit')
  let [file, line, col] = matchlist(line, '\v^([^:]*):(\d*):(\d*)')[1:3]
  execute cmd.' '.file
  call cursor(line, col)
endfunction

let s:grep = { 'cmd' : 'rg --color=always --vimgrep' }
let s:grep['opts'] = '--phony --ansi --delimiter=: --nth=4 '
    \ .'--bind "change:reload('.s:grep.cmd.' {q} || true)" --expect='.join(keys(g:fzf_action), ',')
let s:grep['src'] = s:grep.cmd.' .'
let s:grep['sink'] = function('s:GrepSink')

command! -bang -nargs=? -complete=dir Grep
    \ call fzf#run(fzf#wrap({ 'source': s:grep.src, 'sink*': s:grep.sink, 'options': s:grep.opts }))
