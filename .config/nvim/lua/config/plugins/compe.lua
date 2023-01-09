return {
  'hrsh7th/nvim-compe',
  dependencies = 'GoldsteinE/compe-latex-symbols',
  opts = {
    source = {
      path = true,
      buffer = true,
      tags = true,
      spell = true,
      calc = true,
      emoji = true,
      nvim_lsp = true,
      nvim_lua = true,
      latex_symbols = true,
    },
  },
}
