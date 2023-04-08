local opt = vim.opt_local

opt.omnifunc = 'v:lua.vim.lua_omnifunc'
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set omnifunc< tabstop<'
