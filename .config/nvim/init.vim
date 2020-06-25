set clipboard=unnamedplus
set diffopt+=vertical,hiddenoff,algorithm:histogram
set foldmethod=marker
let &foldtext='substitute(getline(v:foldstart), "\s*$", " " , "")'
set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m
set hidden
set ignorecase smartcase
set inccommand=nosplit " Incrementally show the effect of commands
set lazyredraw
set mouse+=n
set nowrap linebreak breakindent breakindentopt=shift:4,sbr showbreak=↳
set path-=/usr/include " Make the path independent of a language
set shortmess-=c " Do not print completion messages
set spelllang=en,de spellsuggest+=10 " 10 suggestions max
set splitright splitbelow
set suffixes=.bak,~,.swp,.info,.log " Suffixes with lower priority
set tabstop=4 expandtab shiftwidth=0 shiftround
set termguicolors " Enable Truecolor support
set textwidth=80
set undofile
set wildmode=longest:full " Complete till longest common string

" Set the background according to the terminal background
if exists('$BACKGROUND') && $BACKGROUND ==# 'light'
  set background=light
endif

filetype plugin indent on

syntax on
let g:gruvbox_italic = 1
let g:gruvbox_invert_selection = 0
colorscheme gruvbox

let g:LoupeCenterResults = 0

" Lightline configuration
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \     'left':  [ ['mode','paste'], ['relativepath'], ['modified'] ],
    \     'right': [ ['lineinfo'], ['percent'], ['filetype'] ] },
    \ 'inactive': {
    \     'left':  [ ['relativepath'], ['modified'] ],
    \     'right': [ ['lineinfo'], ['percent'] ] }}

augroup init
  autocmd!

  " Remove trailing whitespace and empty lines before writing a file
  autocmd BufWritePre *
      \ let view = winsaveview() | keepp keepj keepm %s/\v\s+$|\n^\s*\n*%$//e | call winrestview(view)

  " Open the quickfix and location list window automatically
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

let mapleader = '\'
let maplocalleader = "\<C-\>"

inoremap <silent> jk <Esc>

noremap <Space> :
nnoremap q<Space> q:

noremap ' `

noremap Q gq
noremap gq gw

inoremap <C-]> <C-x><C-]>
inoremap <C-f> <C-x><C-f>

noremap <C-N> <Esc><Cmd>bnext<CR>
noremap <C-P> <Esc><Cmd>bprev<CR>
noremap <expr> <CR> empty(&buftype) ? "\<C-^>" : "\<CR>"

nnoremap <C-W><CR>  <Cmd>wincmd ^<CR>
nnoremap <C-w><C-]> <Cmd>vertical wincmd ]<CR>
nnoremap <C-w><C-d> <Cmd>vertical wincmd d<CR>
nnoremap <C-w><C-f> <Cmd>vertical wincmd f<CR>
nnoremap <C-w><C-i> <Cmd>vertical wincmd i<CR>

noremap <C-h> <Cmd>wincmd h<CR>
noremap <C-j> <Cmd>wincmd j<CR>
noremap <C-k> <Cmd>wincmd k<CR>
noremap <C-l> <Cmd>wincmd l<CR>

noremap <C-Left>  <Cmd>tabprevious<CR>
noremap <C-Right> <Cmd>tabnext<CR>
noremap <expr> <A-Left>  '<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'
noremap <expr> <A-Right> '<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'

cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

cnoreabbrev vh vert h
cnoreabbrev vf vert sf
cnoreabbrev vv vert sv
cnoreabbrev vb vert sb
cnoreabbrev th  tab h
cnoreabbrev tf  tab sf
cnoreabbrev tv  tab sv
cnoreabbrev tb  tab sb

cnoreabbrev sgr   sil gr
cnoreabbrev sgr!  sil gr!
cnoreabbrev slgr  sil lgr
cnoreabbrev slgr! sil lgr!

nnoremap gs :%s/\v/g<LEFT><LEFT>
xnoremap gs :s/\v/g<LEFT><LEFT>
nnoremap S  :%s/\v\C<<C-r><C-w>>//g<LEFT><LEFT>

nmap <BS> <Plug>(LoupeClearHighlight)

noremap m<CR>    <Cmd>make!<CR>
noremap m<Space> :<C-U>make!<Space>

noremap U <Cmd>MundoToggle<CR>

map ga <Plug>(EasyAlign)

nnoremap <Leader><Leader> <Cmd>Files<CR>
nnoremap <Leader>b        <Cmd>Buffers<CR>
nnoremap <Leader>g        <Cmd>Grep<CR>

noremap <Leader>s <Cmd>ToggleSession<CR>

" Replace the current line by the file under the cursor
nnoremap <Leader>i <Cmd>call append('.', readfile(findfile(expand('<cfile>')))) \| delete<CR>

" Create a fold start..end with the given level
command! -bar -range -nargs=? Fold <line1>,<line2>call init#fold(<q-args>)
nnoremap <expr> zF '<Cmd>Fold '.v:count.' \| silent! call repeat#set("zF", '.v:count.')<CR>'
xnoremap <expr> zF     ':Fold '.v:count.' \| silent! call repeat#set("zF", '.v:count.')<CR>'

" Focus
noremap <Leader>f     <Cmd>Goyo<CR>
noremap <Leader><C-f> <Cmd>Limelight!!<CR>

" Reindent from the given shift width to the buffer's shift width
command! -bar -range=% -nargs=1 Reindent <line1>,<line2>call init#reindent(<q-args>, shiftwidth())

let g:markdown_folding = 1
