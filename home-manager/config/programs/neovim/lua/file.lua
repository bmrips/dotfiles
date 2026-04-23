local M = {}

-- Returns the given string if there is no Makefile, otherwise returns the empty
-- string.
function M.makeOr(str)
  if vim.uv.fs_stat 'makefile' or vim.uv.fs_stat 'Makefile' then
    return ''
  else
    return str
  end
end

return M
