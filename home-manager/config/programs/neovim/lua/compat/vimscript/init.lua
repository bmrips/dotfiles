local M = {}

-- Assign the table's key-value pairs to Vim script variables in the form
-- `vim.g.<prefix><key> = <value>`.
function M.dict_to_vars_with_prefix(prefix, dict)
  for key, value in pairs(dict) do
    vim.g[prefix .. key] = value
  end
end

-- Like `dict_to_vars_with_prefix`, but merges keys recursively, i.e.
-- `{ a = {b = c} }` will be transformed to `vim.g.<prefix>ab = c` instead of
-- `vim.g.<prefix>a = {b = c}`.
function M.dict_to_vars_rec_with_prefix(prefix, dict)
  for key, value in pairs(dict) do
    if type(value) == 'table' then
      M.dict_to_vars_rec_with_prefix(prefix .. key, value)
    else
      vim.g[prefix .. key] = value
    end
  end
end

return M
