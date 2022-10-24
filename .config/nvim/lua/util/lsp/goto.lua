local M = {
  split_cmd = ""
}

local util = vim.lsp.util
local log = require("vim.lsp.log")

M.handler = function(_, result, ctx)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(ctx.method, "No location found")
    return nil
  end

  if M.split_cmd then
    vim.cmd(M.split_cmd)
  end

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1], "utf-8", false)

    if #result > 1 then
      vim.diagnostic.setqflist(util.locations_to_items(result, "utf-8"))
      vim.cmd "copen"
      vim.cmd "wincmd p"
    end
  else
    util.jump_to_location(result, "utf-8", false)
  end
end

M.location = function(loc, split_cmd)
  M.split_cmd = split_cmd
  vim.lsp.buf[loc]()
end

return M
