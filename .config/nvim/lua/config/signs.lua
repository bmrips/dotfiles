local signs = {
  Error = '',
  Warn = '',
  Info = '',
  Hint = '',
}

return setmetatable(signs, {
  __call = function()
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
})
