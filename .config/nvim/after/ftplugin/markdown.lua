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
