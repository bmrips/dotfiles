local M = {}

-- The text shown for a closed fold starting in the given line.
M.foldtext = function(linenr)
  local line = vim.api.nvim_buf_get_lines(0, linenr-1, linenr, true)[1]
  local tabInSpaces = ""
  for _ = 1, vim.opt.tabstop:get() do
    tabInSpaces = tabInSpaces .. " "
  end
  return line:gsub("%s*$", ""):gsub("\t", tabInSpaces)
end

-- Set the given fold mark with the given level the given line.
local addFoldMark = function(linenr, fdm, level)
  local marker = vim.opt_local.commentstring:get():gsub("%%s", fdm..level)
  local line = vim.api.nvim_buf_get_lines(0, linenr-1, linenr, true)[1]
  local new_line = line == ""
    and marker
    or  line:gsub("%s*$", " "..marker)
  vim.api.nvim_buf_set_lines(0, linenr-1, linenr, true, { new_line })
end

-- Create a fold for line1..line2 at the given level.
M.fold = function(info)
  local fdm = vim.opt_local.foldmarker:get()
  local level = (info.args ~= "0" and info.args) or ''
  addFoldMark(info.line1, fdm[1], level)
  if info.line1 ~= info.line2 then
    addFoldMark(info.line2, fdm[2], level)
  end
end

-- Reindent the buffer to the given shift width.
M.reindent = function(info)
  local old, new = vim.fn.shiftwidth(), info.args
  local view = vim.fn.winsaveview()
  vim.cmd.substitute {
    range = { info.line1, info.line2 },
    args = { "@\\v^(\\s*)@\\=repeat(' ', strdisplaywidth(submatch(1))/"..old.."*"..new..")@" },
    mods = vim.tbl_deep_extend("force", info.smods, {
      keepalt = true,
      keepjumps = true,
      keeppatterns = true,
    }),
  }
  vim.fn.winrestview(view)
end

-- Check whether a file exists.
M.existsFile = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Returns the given string if there is no Makefile, otherwise returns the empty
-- string.
M.makeOr = function(str)
  if M.existsFile("makefile") or M.existsFile("Makefile") then
    return ""
  else
    return str
  end
end

return M
