local opt = vim.opt_local

opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set tabstop<'
