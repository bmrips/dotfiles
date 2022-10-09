if not vim.g.no_plugin_maps then
  require("nest").applyKeymaps {
    { "<LocalLeader>", buffer = true, {
      -- View the document in the browser.
      { "v", "<Cmd>MarkdownPreviewToggle<CR>" },
    }}
  }

  vim.b.undo_ftplugin = "mapclear <buffer>"
end
