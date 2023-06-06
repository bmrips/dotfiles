local tty = {}

-- True if in a tty and false otherwise.
tty.is_a_tty = string.match(vim.env.TTY or '', '^/dev/tty.*$') ~= nil

-- True if in a pts and false otherwise.
tty.is_a_pts = not tty.is_a_tty

-- Returns `value` if in tty and `nil` otherwise.
function tty.if_in_tty(value)
  return tty.is_a_tty and value or nil
end

-- Returns `value` if in a pts and `nil` otherwise.
function tty.if_in_pts(value)
  return tty.is_a_pts and value or nil
end

return tty
