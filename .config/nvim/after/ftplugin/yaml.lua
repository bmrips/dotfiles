local opt = vim.opt_local

opt.shiftwidth = 0
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set shiftwidth< tabstop<'
