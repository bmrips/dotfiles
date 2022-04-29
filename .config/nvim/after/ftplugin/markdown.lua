if not vim.g.no_plugin_maps then
  require("nest").applyKeymaps {
    { "<LocalLeader>", buffer = true, {
      -- Preview the document in the browser.
      { "o", "<Cmd>MarkdownPreviewToggle<CR>" },
    }}
  }

  vim.b.undo_ftplugin = "mapclear <buffer>"
end
