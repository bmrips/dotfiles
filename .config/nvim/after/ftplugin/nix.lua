local opt = vim.opt_local

opt.suffixesadd = { '.nix', '/default.nix' }
opt.tabstop = 2

vim.b.undo_ftplugin = 'set suffixesadd< tabstop<'
