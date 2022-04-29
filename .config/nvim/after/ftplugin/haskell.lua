opt = vim.opt_local
util = require("util")

opt.includeexpr = "substitute(v:fname, '\\.', '/', 'g')"
opt.iskeyword:append("'")
opt.softtabstop = -1
opt.shiftwidth = 2
opt.suffixesadd = { ".hs", ".lhs" }

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set iskeyword< shiftwidth< softtabstop< suffixesadd<"

-- Disable treesitter syntax highlighting in insert mode
vim.api.nvim_create_augroup("haskell", {})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "haskell",
  buffer = 0,
  desc = "Disable treesitter syntax highlighting in insert mode",
  callback = function () require("nvim-treesitter.highlight").stop("%") end,
})
