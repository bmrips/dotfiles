local opt = vim.opt_local

opt.errorformat = '%EError: %f:%l:%m,%+Ccontext: %.%#,%WWarning: %m'
opt.makeprg = 'dot -Tpdf % -o %:r.pdf'

-- Write the buffer before compiling
local augroup = vim.api.nvim_create_augroup('dot', { clear = false })
vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  desc = 'Write the buffer before compiling',
  group = augroup,
  buffer = 0,
  callback = function()
    vim.cmd.update()
  end,
})
