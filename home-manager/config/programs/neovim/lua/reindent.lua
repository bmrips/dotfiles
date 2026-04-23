-- Reindent the buffer to the given shift width.
return function(info)
  local old, new = vim.fn.shiftwidth(), info.args
  local view = vim.fn.winsaveview()
  vim.cmd.substitute {
    range = { info.line1, info.line2 },
    args = {
      [[@\v^(\s*)@\=repeat(" ", strdisplaywidth(submatch(1))/]] .. old .. '*' .. new .. ')@',
    },
    mods = vim.tbl_deep_extend('force', info.smods, {
      keepalt = true,
      keepjumps = true,
      keeppatterns = true,
    }),
  }
  vim.fn.winrestview(view)
end
