local opt = vim.opt_local

opt.comments:prepend ':--'
opt.commentstring = '-- %s'

vim.b.undo_ftplugin = 'set comments< commentstring<'
