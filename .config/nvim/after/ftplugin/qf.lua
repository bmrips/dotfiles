opt = vim.opt_local

opt.buflisted = false
opt.relativenumber = false
opt.wrap = false
opt.formatoptions:remove("t")

vim.b.undo_ftplugin = "set buflisted< relativenumber< wrap< formatoptions<"
