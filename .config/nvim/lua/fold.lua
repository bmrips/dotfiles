local fold = {}

-- The text shown for a closed fold starting in the given line.
function fold.text(linenr)
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, true)[1]
  local tabInSpaces = ''
  for _ = 1, vim.opt.tabstop:get() do
    tabInSpaces = tabInSpaces .. ' '
  end
  return line:gsub('%s*$', ''):gsub('\t', tabInSpaces)
end

-- Set the given fold mark with the given level the given line.
local addMark = function(linenr, fdm, level)
  local marker = vim.opt_local.commentstring:get():gsub('%%s', ' ' .. fdm .. level)
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, true)[1]
  local new_line = line == '' and marker or line:gsub('%s*$', ' ' .. vim.pesc(marker))
  vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, true, { new_line })
end

-- Create a fold for line1..line2 at the given level.
function fold.create(info)
  local fdm = vim.opt_local.foldmarker:get()
  local level = (info.args ~= '0' and info.args) or ''
  addMark(info.line1, fdm[1], level)
  if info.line1 ~= info.line2 then
    addMark(info.line2, fdm[2], level)
  end
end

return fold
