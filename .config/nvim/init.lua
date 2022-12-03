require 'impatient'

local fold = require 'fold'
local opt = vim.opt
local util = require 'util'

opt.background = vim.env.BACKGROUND or 'dark' -- Adapt background to terminal background
opt.breakindentopt = { 'shift:4', 'sbr' }
opt.breakindent = true
opt.clipboard = 'unnamedplus'
opt.expandtab = true
opt.foldmethod = 'marker'
opt.foldtext = "v:lua.require'fold'.text(v:foldstart)"
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.guifont = 'JetBrains Mono:h10' -- For Neovide
opt.ignorecase = true
opt.joinspaces = true
opt.jumpoptions:append 'view'
opt.lazyredraw = true
opt.linebreak = true
opt.path = { '', '.' }
opt.shiftround = true
opt.shiftwidth = 0
opt.shortmess:append 'c' -- Do not print completion messages
opt.showbreak = '↳'
opt.smartcase = true
opt.spelllang = { 'en', 'de' }
opt.spellsuggest:append '10' -- 10 suggestions max
opt.splitbelow = true
opt.splitright = true
opt.suffixes = { '.bak', '~', '.swp', '.info', '.log' } -- Suffixes with lower priority
opt.tabstop = 4
opt.termguicolors = true -- Enable Truecolor support
opt.textwidth = 80
opt.undofile = true
opt.wildmode = { 'longest', 'full' } -- Complete till longest common string

-- Fancy diagnostics symbols
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Open the quickfix and location list windows automatically.
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  desc = 'Open the quickfix window automatically',
  nested = true,
  command = 'cwindow',
})
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  desc = 'Open the location list window automatically',
  nested = true,
  command = 'lwindow',
})

-- Highlight yanked text.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Recompile packer.
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'plugins.lua',
  desc = 'Recompile packer',
  command = 'source <afile> | PackerCompile',
})

-- Set Latex as my preferred TeX flavour.
vim.g.tex_flavor = 'latex'

-- Create a fold with `:<range>Fold <level>`.
vim.api.nvim_create_user_command('Fold', fold.create, {
  bar = true,
  range = true,
  nargs = '?',
  desc = 'Create a fold start..end with the given level',
})

-- Reindent the buffer with `:<range>Reindent <new_shift_width>`.
vim.api.nvim_create_user_command('Reindent', util.reindent, {
  bar = true,
  range = '%',
  nargs = 1,
  desc = 'Reindent the buffer to the given shift width',
})

require 'plugins'

-- Mappings
vim.g.mapleader = '\\'
vim.g.maplocalleader = vim.api.nvim_replace_termcodes('<C-\\>', true, true, true)

local mappings = require 'mappings'
local appliedMappings = {
  lsp = {},
}

local nest = require 'nest'
nest.defaults.silent = false
appliedMappings.init = nest.applyKeymaps(mappings.init)

local abbreviations = {
  -- Window splits.
  { 'san', 'sn' },
  { 'ta', 'tab sa' },
  { 'tan', 'tab sn' },
  { 'tb', 'tab sb' },
  { 'tbn', 'tab sbn' },
  { 'tf', 'tab sf' },
  { 'th', 'tab h' },
  { 'ttj', 'tab stj' },
  { 'tts', 'tab sts' },
  { 'tv', 'tab sv' },
  { 'va', 'vert sa' },
  { 'van', 'vert sn' },
  { 'vb', 'vert sb' },
  { 'vbn', 'vert sbn' },
  { 'vf', 'vert sf' },
  { 'vh', 'vert h' },
  { 'vtj', 'vert stj' },
  { 'vts', 'vert sts' },
  { 'vv', 'vert sv' },

  -- Silent grep.
  { 'sgr  ', 'sil gr' },
  { 'sgr! ', 'sil gr!' },
  { 'slgr ', 'sil lgr' },
  { 'slgr!', 'sil lgr!' },
}
for _, abb in ipairs(abbreviations) do
  vim.cmd.cnoreabbrev { abb[1], abb[2] }
end

local lsp_goto = require 'util.lsp.goto'
vim.tbl_extend('force', vim.lsp.handlers, {
  ['textDocument/declaration'] = lsp_goto.handler,
  ['textDocument/definition'] = lsp_goto.handler,
  ['textDocument/implementation'] = lsp_goto.handler,
  ['textDocument/typeDefinition'] = lsp_goto.handler,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Set settings specific to buffers with attached language server',
  nested = true,
  callback = function(args)
    vim.opt_local.signcolumn = 'yes'
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    appliedMappings.lsp[args.buf] = nest.applyKeymaps {
      buffer = args.buf,
      mappings.lsp(client.server_capabilities),
    }
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  desc = 'Revert settings specific to buffers with attached language server',
  nested = true,
  callback = function(args)
    vim.opt_local.signcolumn = vim.opt_global.signcolumn:get()
    nest.revertKeymaps(appliedMappings.lsp[args.buf])
    appliedMappings.lsp[args.buf] = nil
  end,
})

-- Read local configuration files, but with certain commands disabled
opt.secure = true
opt.exrc = true
