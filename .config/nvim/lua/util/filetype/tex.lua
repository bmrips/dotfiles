local tex = {}

-- Insert the given environment at the cursor position.
function tex.createEnvironment(env)
  if env == nil or env == '' then
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1], pos[2]
  local code = {
    '\\begin{' .. env .. '}',
    string.rep(' ', col) .. '\\end{' .. env .. '}',
  }
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, code)
  vim.api.nvim_win_set_cursor(0, { row, col + #code[1] })
end

-- Check whether the buffer is a document, i.e. beginning with `\documentclass`.
function tex.bufIsDocument(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, 1000, false)
  for _, line in ipairs(lines) do
    if line:match '\\documentclass' then
      return true
    end
  end
end

return tex
