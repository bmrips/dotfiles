local opt = vim.opt_local

opt.cindent = true
opt.cinoptions:append ':0'
opt.comments = 's1:/*,mb:*,ex:*/,://'
opt.path = { '.', '', 'include', '$HOME/.local/include', '/usr/local/include', '/usr/include' }

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set cindent< cinoptions< comments< path<'

if not vim.g.no_plugin_maps then
  vim.cmd.inoreabbrev { '#i', '#include' }
  vim.cmd.inoreabbrev { '#d', '#define' }

  vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| abclear <buffer>'
end
