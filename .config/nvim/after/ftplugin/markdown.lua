local opt = vim.opt_local

opt.joinspaces = false
opt.shiftwidth = 0
opt.softtabstop = 0
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set joinspaces< shiftwidth< softtabstop< tabstop<'

if not vim.g.no_plugin_maps then
  --stylua: ignore
  require('nest').applyKeymaps {
    { '<LocalLeader>', buffer = true, {
      { 'v',
        '<Cmd>MarkdownPreviewToggle<CR>',
        desc = 'View document in the browser',
      },
    }},
  }

  vim.b.undo_ftplugin = 'mapclear <buffer>'
end
