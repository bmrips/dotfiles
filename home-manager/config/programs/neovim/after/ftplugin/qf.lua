local opt = vim.opt_local

opt.buflisted = false
opt.relativenumber = false
opt.wrap = false

vim.b.undo_ftplugin = 'set buflisted< relativenumber< wrap<'
