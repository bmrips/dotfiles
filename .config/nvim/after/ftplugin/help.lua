local opt = vim.opt_local

opt.formatoptions:remove("r")
opt.formatoptions:remove("o")

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set formatoptions<"
