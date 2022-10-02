local opt = vim.opt_local

opt.cindent = true
opt.cinoptions:append(":0")
opt.comments = "s1:/*,mb:*,ex:*/,://"
opt.commentstring = "// %s"
opt.define = "^\\s*#\\s*define"
opt.formatoptions:remove("t")
opt.include = "^\\s*#\\s*include"
opt.path = { ".", "", "include", "$HOME/.local/include", "/usr/local/include", "/usr/include" }

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set cindent< cinoptions< comments< commentstring< define< formatoptions< include< path<"

if not vim.g.no_plugin_maps then
  vim.cmd.inoreabbrev { "#i", "#include" }
  vim.cmd.inoreabbrev { "#d", "#define" }

  vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| abclear <buffer>'
end
