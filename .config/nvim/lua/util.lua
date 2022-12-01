local util = {}

-- Reindent the buffer to the given shift width.
util.reindent = function(info)
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
util.existsFile = function(name)
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
util.makeOr = function(str)
  if util.existsFile("makefile") or util.existsFile("Makefile") then
    return ""
  else
    return str
  end
end

return util
