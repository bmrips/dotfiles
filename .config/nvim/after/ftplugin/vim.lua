local opt = vim.opt_local

--opt.comments = '"'
opt.commentstring = '" %s'
opt.formatoptions:remove("r")
opt.formatoptions:remove("o")
opt.include = "^\\s*\\%(source\\|runtime\\%)"
opt.path = opt.runtimepath:get()
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set comments< commentstring< formatoptions< include< path< tabstop<"
