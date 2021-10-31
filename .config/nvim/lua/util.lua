local M = {}

-- An alias for vim.api.nvim_set_keymap, not remapping by default.
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- An alias for vim.api.nvim_buf_set_keymap for the current buffer, not
-- remapping by default.
function M.buf_map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

-- An alias for vim.api.nvim_replace_termcodes.
function M.tc(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
