require("impatient")

local opt = vim.opt
local util = require("util")

opt.background = vim.env.BACKGROUND or "dark" -- Adapt background to terminal background
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
opt.path = { "", "." }
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
opt.wildmode = { "longest", "full" } -- Complete till longest common string
opt.wrap = false

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
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Recompile packer.
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  desc = "Recompile packer",
  command = "source <afile> | PackerCompile",
})

-- Use Lua filetype detection only.
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Set Latex as my preferred TeX flavour.
vim.g.tex_flavor = "latex"

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

require("plugins")

-- Mappings
vim.g.mapleader = "\\"
vim.g.maplocalleader = util.termcode("<C-\\>")

local nest = require("nest")
nest.defaults.options.silent = false
nest.applyKeymaps {
  { "<BS>", "<Plug>(LoupeClearHighlight)", options = {noremap = false} },
  { "<CR>", options = {expr = true},
    function()
      local type = vim.opt_local.buftype:get()
      if type == "quickfix" or type == "prompt" or type == "nofile" then
        return "<CR>"
      else
        return "<C-^>"
      end
    end,
  },
  { "<Space>", ":", mode = "_" },
  { "<Tab>",   function() require("fold-cycle").open() end },
  { "<S-Tab>", function() require("fold-cycle").close() end },
  { "'", "`" },
  { "[d", vim.diagnostic.goto_prev },
  { "]d", vim.diagnostic.goto_next },
  { "g", {
    { "a", "<Plug>(EasyAlign)", mode = "_", options = {noremap = false} },
    { "o", ":Sort<CR>", mode = "_" },
    { "s", ":%s/\\v/g<Left><Left>" },
    { "s", ":s/\\v/g<Left><Left>", mode = "x" },
    { "S", ":sil gr! <C-R><C-w><CR>" },
    { "<C-", {
      { "a>", require("dial.map").inc_gvisual(), mode = "x" },
      { "x>", require("dial.map").dec_gvisual(), mode = "x" },
    }},
  }},
  { "m", {
    { "<CR>",    "<Cmd>make!<CR>" },
    { "<Space>", ":<C-U>make!<Space>" },
  }},
  { "S",  ":%s/\\v\\C<<C-r><C-w>>//g<Left><Left>" },
  { "U", "<Cmd>MundoToggle<CR>" },
  { "z", {
    { "C", function() require("fold-cycle").close_all() end, options = {noremap = false} },
    { "F", "':Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'", mode = "_", options = {expr = true} },
  }},
  { "<A-", {
    { "c>", "<Cmd>tabclose<CR>" },
    { "h>", "'<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'", options = {expr = true} },
    { "j>", "<Cmd>tabnext<CR>" },
    { "k>", "<Cmd>tabprev<CR>" },
    { "l>", "'<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'", options = {expr = true} },
    { "n>", "<Cmd>tabnew<CR>" },
    { "o>", "<Cmd>tabonly<CR>" },
    { "Tab>", "g<Tab>" },
  }},
  { "<C-", {
    { "Left>",  "<C-w><" },
    { "Down>",  "<C-w>-" },
    { "Up>",    "<C-w>+" },
    { "Right>", "<C-w>>" },
    { "a>",  require("dial.map").inc_normal() },
    { "a>",  require("dial.map").inc_visual(), mode = "x" },
    { "h>", "<Cmd>wincmd h<CR>" },
    { "j>", "<Cmd>wincmd j<CR>" },
    { "k>", "<Cmd>wincmd k<CR>" },
    { "l>", "<Cmd>wincmd l<CR>" },
    { "p>", "<C-i>", mode = "_" },
    { "w>", {
      { "<CR>",  "<Cmd>wincmd ^<CR>" },
      { "m",     "<Cmd>WinShift<CR>" },
      { "X",     "<Cmd>WinShift swap<CR>" },
      { "<C-", {
        { "]>", "<Cmd>vertical wincmd ]<CR>" },
        { "d>", "<Cmd>vertical wincmd d<CR>" },
        { "f>", "<Cmd>vertical wincmd f<CR>" },
        { "i>", "<Cmd>vertical wincmd i<CR>" },
      }},
    }},
    { "x>",  require("dial.map").dec_normal() },
    { "x>",  require("dial.map").dec_visual(), mode = "x" },
    { "_>", {
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
  }},
  { "<Leader>", {
    { "c", "<Cmd>Beacon<CR>" },

    { "d", vim.diagnostic.open_float },
    { "D", "<Cmd>TroubleToggle<CR>" },
    { "<C-d>", -- Toggle between inline and virtual line diagnostics
      function()
        local config = vim.diagnostic.config() or
                       { virtual_text = true, virtual_lines = false }
        vim.diagnostic.config {
          virtual_text = not config.virtual_text,
          virtual_lines = not config.virtual_lines,
        }
      end
    },

    -- Focus
    { "z",     "<Cmd>ZenMode<CR>" },
    { "<C-z>", "<Cmd>Twilight<CR>" },

    -- Replace the current line by the file under the cursor
    { "i", "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>" },

    { "n", function() require("notify").dismiss() end },

    { "s", "<Cmd>ToggleSession<CR>" },

    { "t", "<Cmd>Drex<CR>" },
    { "T", ":Drex" },
    { "<C-t>", "<Cmd>DrexDrawerOpen<CR>" },
  }},

  { mode = "i", {
    { "jk", "<Esc>" },
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
