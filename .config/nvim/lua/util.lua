local M = {}

-- Set the given fold mark with the given level the given line.
local addFoldMark = function(linenr, fdm, level)
  local cms = vim.opt_local.commentstring:get()
  local marker = vim.fn.substitute(cms, "%s", " "..fdm..level, "")
  local line = vim.fn.getline(linenr)
  local line = (line == '' and marker)
            or vim.fn.substitute(line, "\\s*$", " "..marker, "")
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
  vim.cmd(
    "keeppatterns keepjumps keepmarks" ..
    info.line1 .. "," .. info.line2 ..
    "substitute@\\v^(\\s*)@\\=repeat(' ', strdisplaywidth(submatch(1))/"..old.."*"..new..")@"
  )
  vim.fn.winrestview(view)
end

-- An alias for vim.api.nvim_set_keymap, not remapping by default.
M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- An alias for vim.api.nvim_buf_set_keymap for the current buffer, not
-- remapping by default.
M.buf_map = function(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

-- An alias for vim.api.nvim_replace_termcodes.
M.termcode = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
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
