local opt = vim.opt_local

opt.tabstop = 2

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| set tabstop<'

-- Automatically insert $ in a pair
vim.b.AutoPairs = vim.tbl_extend('force', vim.g.AutoPairs, { ['$'] = '$' })
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| unlet b:AutoPairs'

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
