local opt = vim.opt_local

opt.formatoptions:remove 't'
opt.joinspaces = false
opt.shiftwidth = 0
opt.softtabstop = 0
opt.suffixesadd = { '.md', 'markdown' }
opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set joinspaces< shiftwidth< softtabstop< suffixesadd< tabstop<'

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
