---@param split_cmd? string
return function(split_cmd)
  ---@param info vim.lsp.LocationOpts.OnList
  return function(info)
    if split_cmd then
      vim.cmd(split_cmd)
    end

    vim.lsp.util.show_document(info.items[1].user_data, 'utf-8')

    if
      #info.items > 2
      -- do not open a quickfix window if there are only two items that refer to
      -- the same line
      or (#info.items == 2 and info.items[1].lnum ~= info.items[2].lnum)
    then
      vim.fn.setqflist({}, ' ', info)
      vim.cmd.copen()
      vim.cmd.wincmd 'p'
    end
  end
end
