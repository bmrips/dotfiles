local tex = {}

-- Insert an environment, whose name is given interactively by the user.
function tex.createEnvironment()
  local env = vim.fn.input 'Environment: '
  if env ~= '' then
    return '\\begin{' .. env .. '}\n\\end{' .. env .. '}<Up><C-o>A<C-g>u'
  else
    return ''
  end
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
