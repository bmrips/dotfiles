local opt = vim.opt_local

opt.commentstring = '-- %s'
opt.tabstop = 2

vim.b.undo_ftplugin = 'set commentstring< tabstop<'
