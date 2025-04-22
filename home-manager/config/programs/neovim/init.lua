vim.loader.enable()

local opt = vim.opt
opt.background = vim.env.BACKGROUND or 'dark' -- Adapt background to terminal background
opt.breakindent = true
opt.breakindentopt = { 'shift:4', 'sbr' }
opt.clipboard = 'unnamedplus'
opt.expandtab = true
opt.exrc = true
opt.fillchars = 'fold: ,foldopen:,foldsep: ,foldclose:'
opt.foldlevelstart = 99
opt.foldmethod = 'marker'
opt.foldtext = "v:lua.require'config.foldtext'(v:foldstart)"
opt.formatoptions:remove 't'
opt.grepformat = '%f:%l:%c:%m'
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
opt.smoothscroll = true
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

vim.g.mapleader = vim.keycode '<Space>'
vim.g.maplocalleader = '\\'

vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  desc = 'Synchronize the background color with the terminal',
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
    if not normal.bg then
      return
    end
    io.write(string.format('\027]11;#%06x\027\\', normal.bg))
  end,
})
vim.api.nvim_create_autocmd('UILeave', {
  desc = 'Stop synchronizing the background color with the terminal',
  callback = function()
    io.write '\027]111\027\\'
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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
  defaults = {
    lazy = true,
  },
  dev = {
    path = '~/projects/neovim/plugins/',
  },
  rocks = {
    enabled = false,
  },
})

vim.cmd.colorscheme 'gruvbox-material'

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰛩 ',
    },
  },
}

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = vim.api.nvim_create_augroup('qflist_auto-open', { clear = true }),
  desc = 'Open the quickfix and location list windows automatically',
  nested = true,
  callback = function(info)
    local openLoclist = info.match:sub(1, 1) == 'l'
    vim.cmd[openLoclist and 'lopen' or 'copen']()
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set Latex as my preferred TeX flavour.
vim.g.tex_flavor = 'latex'

local mappings = require 'config.mappings'

local nest = require 'nest'
nest.defaults.silent = false
nest.applyKeymaps(mappings.init)

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

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Set settings specific to buffers with attached language server',
  nested = true,
  callback = function(args)
    require('util.windows').for_windows_of_buf(args.buf, function(win)
      vim.wo[win][0].signcolumn = 'yes:1'
    end)

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    local client_supports = function(cap)
      client:supports_method(cap, args.buf)
    end

    if client_supports 'inlayHintProvider' then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if client_supports 'textDocument/foldingRange' then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    nest.applyKeymaps {
      buffer = args.buf,
      mappings.lsp(client_supports),
    }
  end,
})
