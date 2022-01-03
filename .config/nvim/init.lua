opt = vim.opt
util = require("util")

opt.breakindentopt = { "shift:4", "sbr" }
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.foldmethod = "marker"
opt.foldtext = "substitute(getline(v:foldstart), '\\s*$', ' ' , '')"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.lazyredraw = true
opt.linebreak = true
opt.mouse:append("n")
opt.path:remove("/usr/include") -- Make the path independent of a language
opt.shiftround = true
opt.shiftwidth = 0
opt.shortmess:remove("c") -- Do not print completion messages
opt.showbreak = "↳"
opt.smartcase = true
opt.spelllang = { "en", "de" }
opt.spellsuggest:append("10") -- 10 suggestions max
opt.splitbelow = true
opt.splitright = true
opt.suffixes = { ".bak", "~", ".swp", ".info", ".log" } -- Suffixes with lower priority
opt.tabstop = 4
opt.termguicolors = true -- Enable Truecolor support
opt.textwidth = 80
opt.undofile = true
opt.wildmode = "longest:full" -- Complete till longest common string
opt.wrap = false

-- Set the background according to the terminal background
if vim.env.BACKGROUND == "light" then opt.background = "light" end

vim.cmd "filetype plugin indent on"

vim.cmd "syntax on"
vim.g.gruvbox_italic = 1
vim.g.gruvbox_invert_selection = 0
vim.cmd "colorscheme gruvbox"

vim.g.LoupeCenterResults = 0

-- Lightline configuration
opt.showmode = false
vim.g.lightline =
    { colorscheme = "gruvbox"
    , active =
        { left  = { {"mode","paste"}, {"relativepath"}, {"modified"} }
        , right = { {"lineinfo"}, {"percent"}, {"filetype"} }
        }
    , inactive =
        { left  = { {"relativepath"}, {"modified"} }
        , right = { {"lineinfo"}, {"percent"} }
        }
    }

vim.cmd([[
  augroup init
    autocmd!

    " Remove trailing whitespace and empty lines before writing a file
    autocmd BufWritePre * let view = winsaveview() | keepp keepj keepm %s/\v\s+$|\s*%(\n\s*)+%$//e | call winrestview(view)

    " Open the quickfix and location list window automatically
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
  augroup END
]])

vim.g.mapleader = "\\"
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<C-\\>", true, true, true)

util.map("i", "jk", "<Esc>")

util.map("", "<Space>", ":")

util.map("", "'", "`")

util.map("", "Q",  "gq")
util.map("", "gq", "gw")

util.map("", "Y", "y$")

util.map("n", "<C-n>", "<Cmd>bnext<CR>")
util.map("n", "<C-p>", "<Cmd>bprev<CR>")
util.map("n", "<CR>",  "&buftype != 'quickfix' && &buftype != 'prompt' ? '<C-^>' : '<CR>'", {expr = true})

util.map("n", "<C-W><CR>",  "<Cmd>wincmd ^<CR>")
util.map("n", "<C-w><C-]>", "<Cmd>vertical wincmd ]<CR>")
util.map("n", "<C-w><C-d>", "<Cmd>vertical wincmd d<CR>")
util.map("n", "<C-w><C-f>", "<Cmd>vertical wincmd f<CR>")
util.map("n", "<C-w><C-i>", "<Cmd>vertical wincmd i<CR>")

util.map("n", "<C-h>", "<Cmd>wincmd h<CR>")
util.map("n", "<C-j>", "<Cmd>wincmd j<CR>")
util.map("n", "<C-k>", "<Cmd>wincmd k<CR>")
util.map("n", "<C-l>", "<Cmd>wincmd l<CR>")

util.map("n", "<C-Left>",  "<C-w><")
util.map("n", "<C-Down>",  "<C-w>-")
util.map("n", "<C-Up>",    "<C-w>+")
util.map("n", "<C-Right>", "<C-w>>")

util.map("n", "<C-Left>",  "<Cmd>tabprevious<CR>")
util.map("n", "<C-Right>", "<Cmd>tabnext<CR>")
util.map("n", "<A-Left>",  "'<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'", {expr = true})
util.map("n", "<A-Right>", "'<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'", {expr = true})

util.map("n", "gs", ":%s/\\v/g<Left><Left>")
util.map("x", "gs", ":s/\\v/g<Left><Left>")
util.map("n", "S",  ":%s/\\v\\C<<C-r><C-w>>//g<Left><Left>")
util.map("n", "gS", ":sil gr! <C-R><C-w><CR>")

util.map("n", "<BS>", "<Plug>(LoupeClearHighlight)", {noremap = false})

util.map("n", "m<CR>",    "<Cmd>make!<CR>")
util.map("n", "m<Space>", ":<C-U>make!<Space>")

util.map("n", "U", "<Cmd>MundoToggle<CR>")

util.map("", "ga", "<Plug>(EasyAlign)", {noremap = false})

util.map("n", "<Leader><Leader>", "<Cmd>Files<CR>")
util.map("n", "<Leader>b",        "<Cmd>Buffers<CR>")
util.map("n", "<Leader>g",        "<Cmd>Grep<CR>")

-- Replace the current line by the file under the cursor
util.map("n", "<Leader>i", "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>")

-- Create a fold start..end with the given level
vim.cmd "command! -bar -range -nargs=? Fold <line1>,<line2>call init#fold(<q-args>)"
util.map("n", "zF", "'<Cmd>Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'", {expr = true})
util.map("x", "zF",     "':Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'", {expr = true})

util.map("n", "<Leader>s", "<Cmd>ToggleSession<CR>")

-- Focus
util.map("", "<Leader>f",     "<Cmd>Goyo<CR>")
util.map("", "<Leader><C-f>", "<Cmd>Limelight!!<CR>")

-- Reindent from the given shift width to the buffer's shift width
vim.cmd "command! -bar -range=% -nargs=1 Reindent <line1>,<line2>call init#reindent(<q-args>, shiftwidth())"

util.map("c", "<C-j>", "<Down>")
util.map("c", "<C-k>", "<Up>")

util.map("c", "<C-n>", 'getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-n>"', {expr = true})
util.map("c", "<C-p>", 'getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>?<C-r>/" : "<C-p>"', {expr = true})

vim.cmd "cnoreabbrev sgr   sil gr"
vim.cmd "cnoreabbrev sgr!  sil gr!"
vim.cmd "cnoreabbrev slgr  sil lgr"
vim.cmd "cnoreabbrev slgr! sil lgr!"

vim.g.markdown_folding = 1

require("colorizer").setup()

-- Treesitter
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
  },
  indent = { enable = true },
}

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Read local configuration files, but with certain commands disabled
opt.secure = true
opt.exrc = true
