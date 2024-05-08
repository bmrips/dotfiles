local M = {}

-- True if in a tty and false otherwise.
M.is_a_tty = string.match(vim.env.TTY or '', '^/dev/console$') ~= nil

-- True if in a pts and false otherwise.
M.is_a_pts = not M.is_a_tty

-- Returns `value` if in tty and `nil` otherwise.
function M.if_in_tty(value)
  return M.is_a_tty and value or nil
end

-- Returns `value` if in a pts and `nil` otherwise.
function M.if_in_pts(value)
  return M.is_a_pts and value or nil
end

return M
