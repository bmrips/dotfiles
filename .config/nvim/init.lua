opt = vim.opt
util = require("util")

opt.background = vim.env.BACKGROUND -- Background according to the terminal background
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
opt.signcolumn = "yes"
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

vim.g.gruvbox_italic = 1
vim.g.gruvbox_invert_selection = 0
vim.cmd "colorscheme gruvbox"

-- Lightline configuration
opt.showmode = false
vim.g.lightline = {
  colorscheme = "gruvbox",
  active = {
    left  = { {"mode","paste"}, {"relativepath"}, {"modified"} },
    right = { {"lineinfo"}, {"percent"}, {"filetype"} },
  },
  inactive = {
    left  = { {"relativepath"}, {"modified"} },
    right = { {"lineinfo"}, {"percent"} },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  desc = "Remove trailing whitespace and empty lines before writing a file",
  callback = util.removeTrailingWhitespace,
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  desc = "Open the quickfix window automatically",
  nested = true,
  command = "cwindow",
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "l*",
  desc = "Open the location list window automatically",
  nested = true,
  command = "lwindow",
})

-- Use Lua filetype detection only
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.g.tex_flavor = "latex" -- Set Latex as my favoured TeX flavour

vim.g.LoupeCenterResults = 0
vim.g.AutoPairsShortcutJump = ""

require("colorizer").setup()
require("virt-column").setup()
require("trouble").setup() -- LSP diagnostics

-- Treesitter
require("nvim-treesitter.configs").setup {
  highlight = { enable = true, },
  indent = { enable = true },
}

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Create a fold start..end with the given level
vim.api.nvim_create_user_command("Fold", util.fold, {
  bar = true,
  range = true,
  nargs = "?",
  desc = "Create a fold start..end with the given level",
})

-- Reindent the buffer to the given shift width
vim.api.nvim_create_user_command("Reindent", util.reindent, {
  bar = true,
  range = "%",
  nargs = 1,
  desc = "Reindent the buffer to the given shift width",
})

-- Mappings
vim.g.mapleader = "\\"
vim.g.maplocalleader = util.tc("<C-\\>")

nest = require("nest")
nest.defaults.options.silent = false
nest.applyKeymaps {
  { "jk", "<Esc>", mode = "i" },

  { mode = "_", {
    { "<Space>", ":" },
    { "'", "`" },
  }},

  { "<CR>",  "&buftype !~ 'quickfix\\|prompt\\|nofile' ? '<C-^>' : '<CR>'", options = {expr = true} },

  { "<C-", {
    { "n>", "<Cmd>bnext<CR>" },
    { "p>", "<Cmd>bprev<CR>" },

    { "w>", {
      { "<CR>",  "<Cmd>wincmd ^<CR>" },
      { "<C-]>", "<Cmd>vertical wincmd ]<CR>" },
      { "<C-d>", "<Cmd>vertical wincmd d<CR>" },
      { "<C-f>", "<Cmd>vertical wincmd f<CR>" },
      { "<C-i>", "<Cmd>vertical wincmd i<CR>" },
    }},

    { "h>", "<Cmd>wincmd h<CR>" },
    { "j>", "<Cmd>wincmd j<CR>" },
    { "k>", "<Cmd>wincmd k<CR>" },
    { "l>", "<Cmd>wincmd l<CR>" },

    { "Left>",  "<C-w><" },
    { "Down>",  "<C-w>-" },
    { "Up>",    "<C-w>+" },
    { "Right>", "<C-w>>" },
  }},

  { "<A-", {
    { "n>", "<Cmd>tabnew<CR>" },
    { "c>", "<Cmd>tabclose<CR>" },
    { "k>", "<Cmd>tabprev<CR>" },
    { "j>", "<Cmd>tabnext<CR>" },
    { "h>", "'<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'", options = {expr = true} },
    { "l>", "'<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'", options = {expr = true} },
    { "Tab>", "g<Tab>" },
    { "o>", "<Cmd>tabonly<CR>" },
  }},

  { "S",  ":%s/\\v\\C<<C-r><C-w>>//g<Left><Left>" },

  { 'g', {
    { "s", ":%s/\\v/g<Left><Left>" },
    { "s", ":s/\\v/g<Left><Left>", mode = "x" },
    { "S", ":sil gr! <C-R><C-w><CR>" },

    { "a", "<Plug>(EasyAlign)", options = {noremap = false} },
  }},

  { "<BS>", "<Plug>(LoupeClearHighlight)", options = {noremap = false} },

  { "m", {
    { "<CR>",    "<Cmd>make!<CR>" },
    { "<Space>", ":<C-U>make!<Space>" },
  }},

  { "U", "<Cmd>MundoToggle<CR>" },

  { "<Leader>", {
    { "<Leader>", "<Cmd>Files<CR>" },
    { "b",        "<Cmd>Buffers<CR>" },
    { "g",        "<Cmd>Grep<CR>" },

    -- Replace the current line by the file under the cursor
    { "i", "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>" },

    { "s", "<Cmd>ToggleSession<CR>" },

    -- Focus
    { "f",     "<Cmd>Goyo<CR>" },
    { "<C-f>", "<Cmd>Limelight!!<CR>" },

    { "t", "<Cmd>TroubleToggle<CR>" },
  }},

  { "z", options = {expr = true}, {
    { "F", "'<Cmd>Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'" },
    { "F",     "':Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'", mode = "x" },
  }},

  { mode = "c", "<C-", {
    { "j>", "<Down>" },
    { "k>", "<Up>" },

    { "n>", 'getcmdtype() =~ "[/?]" ? "<CR>/<C-r>/" : "<C-n>"', options = {expr = true} },
    { "p>", 'getcmdtype() =~ "[/?]" ? "<CR>?<C-r>/" : "<C-p>"', options = {expr = true} },
  }},
}

vim.cmd "cnoreabbrev sgr   sil gr"
vim.cmd "cnoreabbrev sgr!  sil gr!"
vim.cmd "cnoreabbrev slgr  sil lgr"
vim.cmd "cnoreabbrev slgr! sil lgr!"

-- Read local configuration files, but with certain commands disabled
opt.secure = true
opt.exrc = true
