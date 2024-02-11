local M = {}

-- Check whether a file exists.
function M.exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Returns the given string if there is no Makefile, otherwise returns the empty
-- string.
function M.makeOr(str)
  if M.exists 'makefile' or M.exists 'Makefile' then
    return ''
  else
    return str
  end
end

return M
