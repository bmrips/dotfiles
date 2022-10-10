local M = {}

-- Set the given fold mark with the given level the given line.
local addFoldMark = function(linenr, fdm, level)
  local cms = vim.opt_local.commentstring:get()
  local marker = vim.fn.substitute(cms, "%s", " "..fdm..level, "")
  local line = vim.fn.getline(linenr)
  local line = (line == '' and marker)
            or vim.fn.substitute(line, "\\s*$", marker, "")
  vim.fn.setline(linenr, line)
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


M.existsFile = function(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.makeOr = function(str)
  if M.existsFile("makefile") or M.existsFile("Makefile") then
    return ""
  else
    return str
  end
end

return M
