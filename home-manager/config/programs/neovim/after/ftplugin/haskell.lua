local opt = vim.opt_local

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.iskeyword:append "'"
opt.suffixesadd = { '.hs', '.lhs' }
opt.path:append { 'app/', 'src/', 'tests/' }
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set includeexpr< iskeyword< tabstop< suffixesadd<'
