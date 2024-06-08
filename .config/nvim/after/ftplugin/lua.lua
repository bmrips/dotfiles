local opt = vim.opt_local

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.omnifunc = 'v:lua.vim.lua_omnifunc'
opt.path:append 'lua/'
opt.suffixesadd = { '.lua', '/init.lua' }
opt.tabstop = 2

for _, dir in ipairs(vim.api.nvim_get_runtime_file('lua', true)) do
  opt.path:append(dir)
end

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set includeexpr< omnifunc< path< suffixesadd< tabstop<'
