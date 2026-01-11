local opt = vim.opt_local

opt.formatoptions:remove 't'
opt.joinspaces = false
opt.shiftwidth = 0
opt.softtabstop = 0
opt.suffixesadd = { '.md', 'markdown' }
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set joinspaces< shiftwidth< softtabstop< suffixesadd< tabstop<'

vim.b.undo_ftplugin = 'mapclear <buffer>'
