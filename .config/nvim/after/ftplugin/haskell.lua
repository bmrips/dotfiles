local opt = vim.opt_local

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.iskeyword:append "'"
opt.shiftwidth = 2
opt.suffixesadd = { '.hs', '.lhs' }

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set includeexpr< iskeyword< shiftwidth< suffixesadd<'
