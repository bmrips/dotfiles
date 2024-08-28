local opt = vim.opt_local

opt.errorformat = '%EError: %f:%l:%m,%+Ccontext: %.%#,%WWarning: %m'
opt.makeprg = 'dot -Tpdf % -o %:r.pdf'

-- Write the buffer before compiling
local augroup = vim.api.nvim_create_augroup('dot', { clear = false })
vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  group = augroup,
  buffer = 0,
  desc = 'Write the buffer before compiling',
  callback = function()
    vim.cmd.update()
  end,
})
