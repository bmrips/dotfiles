-- Fit the window size to the text width.
vim.api.nvim_create_augroup("focus", {})
vim.api.nvim_create_autocmd("User", {
  group = "focus",
  pattern = "GoyoEnter",
  desc = "Fit the window size to the text width",
  callback =
    function ()
      vim.cmd("Goyo " .. vim.opt_local.textwidth:get() .. "x")
    end,
})
