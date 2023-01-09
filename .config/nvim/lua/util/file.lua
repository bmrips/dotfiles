local file = {}

-- Check whether a file exists.
function file.exists(name)
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
function file.makeOr(str)
  if file.exists 'makefile' or file.exists 'Makefile' then
    return ''
  else
    return str
  end
end

return file
