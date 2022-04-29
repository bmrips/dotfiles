opt = vim.opt_local

opt.foldmethod = "manual"

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| set foldmethod<"
