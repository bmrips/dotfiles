return {
  'NvChad/nvim-colorizer.lua',
  cond = vim.opt.termguicolors:get(),
  opts = {
    filetypes = {
      '!lazy',
      '!markdown',
      '!yaml',
      '*',
    },
  },
}
