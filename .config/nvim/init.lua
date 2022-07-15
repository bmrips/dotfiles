local opt = vim.opt
local util = require("util")

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
opt.joinspaces = true
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

-- Remove trailing whitespace and empty lines before writing a file.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  desc = "Remove trailing whitespace and empty lines before writing a file",
  callback = util.removeTrailingWhitespace,
})

-- Open the quickfix and location list windows automatically.
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

-- Highlight yanked text.
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Use Lua filetype detection only.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Set Latex as my preferred TeX flavour.
vim.g.tex_flavor = "latex"

-- Do not display off-screen matches
vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
-- Defer highlighting to improve performance
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_transmute_enabled = 1

-- Do not center search results on n/N.
vim.g.LoupeCenterResults = 0

-- Do not create the <M-n> shortcut to map it myself later.
vim.g.AutoPairsShortcutJump = ""

-- Prevent window content to be shifted on split creation.
require("stabilize").setup()

-- Colorize colour tags.
require("colorizer").setup()

-- Display a character as the colorcolumn.
require("virt-column").setup()

-- Cycle through folds.
require("fold-cycle").setup()

-- Enhanced notifications with `vim.ui.notify`.
vim.notify = require("notify")

-- Enhanced increment/decrement.
local augend = require("dial.augend")
require("dial.config").augends:register_group {
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%d.%m.%Y"],
    augend.date.alias["%d.%m.%y"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%d.%m."],
    augend.date.alias["%H:%M"],
    augend.constant.alias.de_weekday,
    augend.constant.alias.de_weekday_full,
  }
}

-- Enhanced :sort
require("sort").setup()
vim.cmd "cnoreabbrev sort Sort"

-- Do not close the current markdown preview when changing the buffer.
vim.g.mkdp_auto_close = 0

-- Inspect LSP diagnostics.
require("trouble").setup()

-- Enable treesitter highlighting, indentation and folding.
require("nvim-treesitter.configs").setup {
  highlight = { enable = true, },
  indent = { enable = true },
}

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Completion, with all sources enabled.
require("compe").setup {
  source = {
    path = true,
    buffer = true,
    tags = true,
    spell = true,
    calc = true,
    emoji = true,
    nvim_lsp = true,
    nvim_lua = true,
  },
}

-- Create a fold with `:<range>Fold <level>`.
vim.api.nvim_create_user_command("Fold", util.fold, {
  bar = true,
  range = true,
  nargs = "?",
  desc = "Create a fold start..end with the given level",
})

-- Reindent the buffer with `:<range>Reindent <new_shift_width>`.
vim.api.nvim_create_user_command("Reindent", util.reindent, {
  bar = true,
  range = "%",
  nargs = 1,
  desc = "Reindent the buffer to the given shift width",
})

-- Mappings
vim.g.mapleader = "\\"
vim.g.maplocalleader = util.termcode("<C-\\>")

local nest = require("nest")
nest.defaults.options.silent = false
nest.applyKeymaps {
  { "jk", "<Esc>", mode = "i" },

  { mode = "_", {
    { "<Space>", ":" },
    { "'", "`" },
    { '<C-p>', "<C-i>" },

    { "ga", "<Plug>(EasyAlign)", options = {noremap = false} },

    { "go", ":Sort<CR>" },
  }},

  { "<CR>",  "&buftype !~ 'quickfix\\|prompt\\|nofile' ? '<C-^>' : '<CR>'", options = {expr = true} },

  -- Enhanced increment/decrement
  { "<C-a>",  require("dial.map").inc_normal() },
  { "<C-a>",  require("dial.map").inc_visual(), mode = "v" },
  { "<C-x>",  require("dial.map").dec_normal() },
  { "<C-x>",  require("dial.map").dec_visual(), mode = "v" },
  { "g<C-a>", require("dial.map").inc_gvisual(), mode = "v" },
  { "g<C-x>", require("dial.map").dec_gvisual(), mode = "v" },

  { "<Tab>",   require("fold-cycle").open },
  { "<S-Tab>", require("fold-cycle").close },
  { "zC",      require("fold-cycle").close_all, {noremap = false} },

  { "<C-", {
    { "w>", {
      { "<CR>",  "<Cmd>wincmd ^<CR>" },
      { "m",     "<Cmd>WinShift<CR>" },
      { "X",     "<Cmd>WinShift swap<CR>" },
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
  }},

  { "<BS>", "<Plug>(LoupeClearHighlight)", options = {noremap = false} },

  { "m", {
    { "<CR>",    "<Cmd>make!<CR>" },
    { "<Space>", ":<C-U>make!<Space>" },
  }},

  { "U", "<Cmd>MundoToggle<CR>" },

  { "<Leader>", {
    { "c",     "<Cmd>Beacon<CR>" },

    -- Focus
    { "f",     "<Cmd>Goyo<CR>" },
    { "<C-f>", "<Cmd>Limelight!!<CR>" },

    -- Replace the current line by the file under the cursor
    { "i", "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>" },

    { "s", "<Cmd>ToggleSession<CR>" },

    { "t", "<Cmd>TroubleToggle<CR>" },
  }},

  -- Fzf
  { "<C-_>", {
    { ":",     "<Cmd>FzfLua command_history<CR>" },
    { "/",     "<Cmd>FzfLua search_history<CR>" },
    { "?",     "<Cmd>FzfLua search_history<CR>" },
    { "a",     "<Cmd>FzfLua args<CR>" },
    { "b",     "<Cmd>FzfLua buffers<CR>" },
    { "c",     "<Cmd>FzfLua commands<CR>" },
    { "C",     "<Cmd>FzfLua colorschemes<CR>" },
    { "f",     "<Cmd>FzfLua files<CR>" },
    { "F",     "<Cmd>FzfLua oldfiles<CR>" },
    { "<C-f>", "<Cmd>FzfLua git_files<CR>" },
    { "g",     "<Cmd>FzfLua live_grep<CR>" },
    { "G",     "<Cmd>FzfLua live_grep_resume<CR>" },
    { "<C-g>", "<Cmd>FzfLua live_grep_glob<CR>" },
    { "h",     "<Cmd>FzfLua help_tags<CR>" },
    { "H",     "<Cmd>FzfLua man_pages<CR>" },
    { "j",     "<Cmd>FzfLua jumps<CR>" },
    { "l",     "<Cmd>FzfLua lines<CR>" },
    { "L",     "<Cmd>FzfLua blines<CR>" },
    { "m",     "<Cmd>FzfLua marks<CR>" },
    { "o",     "<Cmd>FzfLua grep_cword<CR>" },
    { "O",     "<Cmd>FzfLua grep_cWORD<CR>" },
    { "<C-o>", "<Cmd>FzfLua grep_visual<CR>" },
    { "p",     "<Cmd>FzfLua packadd<CR>" },
    { "q",     "<Cmd>FzfLua quickfix<CR>" },
    { "Q",     "<Cmd>FzfLua loclist<CR>" },
    { "r",     "<Cmd>FzfLua registers<CR>" },
    { "s",     "<Cmd>FzfLua spell_suggest<CR>" },
    { "t",     "<Cmd>FzfLua filetypes<CR>" },
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

local abbreviations = {
  -- Window splits.
  { "san",      "sn" },
  { "ta",   "tab sa" },
  { "tan",  "tab sn" },
  { "tb",   "tab sb" },
  { "tbn",  "tab sbn" },
  { "tf",   "tab sf" },
  { "th",   "tab h" },
  { "ttj",  "tab stj" },
  { "tts",  "tab sts" },
  { "tv",   "tab sv" },
  { "va",  "vert sa" },
  { "van", "vert sn" },
  { "vb",  "vert sb" },
  { "vbn", "vert sbn" },
  { "vf",  "vert sf" },
  { "vh",  "vert h" },
  { "vtj", "vert stj" },
  { "vts", "vert sts" },
  { "vv",  "vert sv" },

  -- Silent grep.
  { "sgr  ", "sil gr" },
  { "sgr! ", "sil gr!" },
  { "slgr ", "sil lgr" },
  { "slgr!", "sil lgr!" },
}
for _, abb in ipairs(abbreviations) do
  vim.cmd("cnoreabbrev " .. abb[1] .. " " .. abb[2])
end

-- Read local configuration files, but with certain commands disabled
opt.secure = true
opt.exrc = true
