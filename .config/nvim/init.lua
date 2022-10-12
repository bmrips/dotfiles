require("impatient")

local opt = vim.opt
local util = require("util")

opt.background = vim.env.BACKGROUND or "dark" -- Adapt background to terminal background
opt.breakindentopt = { "shift:4", "sbr" }
opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.foldmethod = "marker"
opt.foldtext = "v:lua.require'util'.foldtext(v:foldstart)"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.guifont = "JetBrains Mono:h10" -- For Neovide
opt.ignorecase = true
opt.joinspaces = true
opt.jumpoptions:append("view")
opt.lazyredraw = true
opt.linebreak = true
opt.mouse:append("n")
opt.path = { "", "." }
opt.shiftround = true
opt.shiftwidth = 0
opt.shortmess:append("c") -- Do not print completion messages
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
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<C-\\>", true, true, true)

local mappings = require("mappings")

local nest = require("nest")
nest.defaults.options.silent = false
nest.applyKeymaps(mappings.default)

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
  vim.cmd.cnoreabbrev { abb[1], abb[2] }
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Set settings specific to buffers with attached language server",
  nested = true,
  callback = function()
    -- Set 'signcolumn' for filetypes with a language server.
    vim.opt_local.signcolumn = "yes"
    nest.applyKeymaps(mappings.lsp)
  end
})

-- Read local configuration files, but with certain commands disabled
opt.secure = true
opt.exrc = true
