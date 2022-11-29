local opt = vim.opt_local

opt.comments = ':"'
opt.formatoptions:remove("r")
opt.formatoptions:remove("o")
opt.include = "^\\s*\\%(source\\|runtime\\%)"
opt.path = opt.runtimepath:get()
opt.shiftwidth = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set comments< formatoptions< include< path< tabstop<"
