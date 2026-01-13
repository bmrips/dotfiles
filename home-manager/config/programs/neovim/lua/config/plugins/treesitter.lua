local localDir = vim.env.NVIM_TREESITTER

local source = localDir and {
  dir = localDir,
  pin = true,
} or {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
}

return vim.tbl_deep_extend('keep', source, {
  name = 'nvim-treesitter',
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Enable tree-sitter if available',
      group = vim.api.nvim_create_augroup('nvim-treesitter', { clear = false }),
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.opt_local.foldmethod = 'expr'
          vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.opt_local.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
        end
      end,
    })
  end,
})
