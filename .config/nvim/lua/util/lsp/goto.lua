local lsp_goto = {
  split_cmd = '',
}

local util = vim.lsp.util
local log = require 'vim.lsp.log'

function lsp_goto.handler(_, result, ctx)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end

  if lsp_goto.split_cmd then
    vim.cmd(lsp_goto.split_cmd)
  end

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1], 'utf-8', false)

    if #result > 1 then
      vim.diagnostic.setqflist(util.locations_to_items(result, 'utf-8'))
      vim.cmd 'copen'
      vim.cmd 'wincmd p'
    end
  else
    util.jump_to_location(result, 'utf-8', false)
  end
end

function lsp_goto.location(loc, split_cmd)
  lsp_goto.split_cmd = split_cmd
  vim.lsp.buf[loc]()
end

return lsp_goto
