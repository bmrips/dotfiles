local opt = vim.opt_local

opt.foldmethod = "manual"
opt.formatoptions:remove("r")
opt.formatoptions:remove("o")

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set foldmethod< formatoptions<"
