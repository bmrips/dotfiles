local opt = vim.opt_local

opt.comments = ":#"
opt.commentstring = "# %s"
opt.formatoptions:remove("t")
opt.formatoptions:append("l")
opt.wrap = true

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set comments< commentstring< formatoptions<"
