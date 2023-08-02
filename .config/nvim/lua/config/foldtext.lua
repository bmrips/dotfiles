return function(linenr)
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, true)[1]
  local tabInSpaces = string.rep(' ', vim.opt.tabstop:get())
  return line:gsub('%s*$', ''):gsub('\t', tabInSpaces)
end
