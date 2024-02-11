vim.loader.enable()

local opt = vim.opt
opt.background = vim.env.BACKGROUND or 'dark' -- Adapt background to terminal background
opt.breakindent = true
opt.breakindentopt = { 'shift:4', 'sbr' }
opt.clipboard = require('util.tty').if_in_pts 'unnamedplus'
opt.diffopt:append 'linematch:60'
opt.expandtab = true
opt.exrc = true
opt.fillchars = 'fold: ,foldopen:,foldsep: ,foldclose:'
opt.foldmethod = 'marker'
opt.foldtext = "v:lua.require'config.foldtext'(v:foldstart)"
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.guifont = 'JetBrainsMono NF SemiBold:h10' -- For Neovide
opt.ignorecase = true
opt.joinspaces = true
opt.jumpoptions:append 'view'
opt.lazyredraw = true
opt.linebreak = true
opt.listchars = { eol = '󰌑', tab = '› ', trail = '·' }
opt.modeline = true
opt.path = { '', '.' }
opt.pumheight = 20
opt.shiftround = true
opt.shiftwidth = 0
opt.shortmess:append 'c' -- Do not print completion messages
opt.showbreak = '↳'
opt.smartcase = true
opt.spelllang = { 'en', 'de' }
opt.spellsuggest:append '10' -- 10 suggestions max
opt.splitbelow = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.suffixes = { '.bak', '~', '.swp', '.info', '.log' } -- Suffixes with lower priority
opt.tabstop = 4
opt.termguicolors = vim.env.COLORTERM ~= nil -- Enable Truecolor support
opt.textwidth = 80
opt.undofile = true
opt.wildmode = { 'longest', 'full' } -- Complete till longest common string

vim.g.mapleader = '\\'
vim.g.maplocalleader = vim.api.nvim_replace_termcodes('<C-\\>', true, true, true)

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
opt.runtimepath:prepend(lazypath)

require('lazy').setup('config.plugins', {
  dev = {
    path = '~/projects/neovim/plugins/',
    patterns = { 'f1rstlady' },
  },
  performance = {
    rtp = {
      paths = {
        '/usr/share/vim/vimfiles',
      },
      disable_plugins = {
        'matchit',
        'matchparen',
        'netrwPlugin',
      },
    },
  },
})

vim.cmd.colorscheme 'gruvbox-material'

require 'config.signs'()

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

-- Set Latex as my preferred TeX flavour.
vim.g.tex_flavor = 'latex'

-- Create a fold with `:<range>Fold <level>`.
vim.api.nvim_create_user_command('Fold', require('util.fold').create, {
  bar = true,
  range = true,
  nargs = '?',
  desc = 'Create a fold start..end with the given level',
})

-- Reindent the buffer with `:<range>Reindent <new_shift_width>`.
vim.api.nvim_create_user_command('Reindent', require 'util.reindent', {
  bar = true,
  range = '%',
  nargs = 1,
  desc = 'Reindent the buffer to the given shift width',
})

-- Mappings
local mappings = require 'config.mappings'
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
    require('util.windows').for_windows_of_buf(args.buf, function(win)
      vim.wo[win].signcolumn = 'yes'
    end)

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.server_capabilities.documentFormatProvider then
      vim.bo[args.buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end

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
    require('util.windows').for_windows_of_buf(args.buf, function(win)
      vim.wo[win].signcolumn = 'no'
    end)

    vim.bo[args.buf].formatexpr = ''

    nest.revertKeymaps(appliedMappings.lsp[args.buf])
    appliedMappings.lsp[args.buf] = nil
  end,
})
