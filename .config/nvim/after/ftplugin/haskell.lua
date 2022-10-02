local opt = vim.opt_local

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.iskeyword:append("'")
opt.softtabstop = -1
opt.shiftwidth = 2
opt.suffixesadd = { ".hs", ".lhs" }

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set iskeyword< shiftwidth< softtabstop< suffixesadd<"
