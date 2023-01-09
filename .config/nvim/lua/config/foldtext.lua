return function(linenr)
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, true)[1]
  local tabInSpaces = ''
  for _ = 1, vim.opt.tabstop:get() do
    tabInSpaces = tabInSpaces .. ' '
  end
  return line:gsub('%s*$', ''):gsub('\t', tabInSpaces)
end
