local opt = vim.opt_local

opt.formatoptions:remove 't'

vim.b.undo_ftplugin = 'set formatoptions<'
