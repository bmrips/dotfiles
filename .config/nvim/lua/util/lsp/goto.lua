local M = {}

local util = vim.lsp.util
local log = require 'vim.lsp.log'

local split_command = ''

function M.handler(_, result, ctx)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, 'No location found')
    return nil
  end

  if split_command then
    vim.cmd(split_command)
  end

  if not vim.islist(result) then
    result = { result }
  end

  util.jump_to_location(result[1], 'utf-8', false)

  if #result > 1 then
    local items = util.locations_to_items(result, 'utf-8')
    vim.fn.setqflist(items)
    vim.cmd.copen()
    vim.cmd.wincmd 'p'
  end
end

function M.location(loc, split_cmd)
  split_command = split_cmd
  vim.lsp.buf[loc]()
end

return M
