local opt = vim.opt_local

opt.expandtab = false
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| set expandtab< tabstop<"
