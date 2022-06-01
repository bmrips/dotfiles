local opt = vim.opt_local

opt.shiftwidth = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| set shiftwidth<"
