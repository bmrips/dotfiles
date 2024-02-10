local opt = vim.opt_local

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.omnifunc = 'v:lua.vim.lua_omnifunc'
opt.path:append 'lua/'
opt.suffixesadd = { '.lua' }
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set includeexpr< omnifunc< path< suffixesadd< tabstop<'
