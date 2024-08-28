local word_with_umlauts =
  [[\%(-\?\d\+\%(\.\d\+\)\?\|[A-ZÄÖÜa-zäöüß_][0-9A-ZÄÖÜa-zäöüß_]*\%([\-.][0-9A-ZÄÖÜa-zäöü_]+\)*\)]]

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'dmitmel/cmp-cmdline-history',
    'f3fora/cmp-spell',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-calc',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-omni',
    'hrsh7th/cmp-path',
    'kdheepak/cmp-latex-symbols',
    'octaltree/cmp-look',
    {
      'petertriho/cmp-git',
      dependencies = 'nvim-lua/plenary.nvim',
      config = true,
    },
    'saadparwaiz1/cmp_luasnip',
  },
  opts = function()
    local cmp = require 'cmp'
    return {
      performance = {
        debounce = 0,
        throttle = 0,
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm { select = false },
        ['<C-x>e'] = cmp.mapping.complete {
          config = {
            sources = {
              { name = 'emoji' },
            },
          },
        },
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'omni' },
        {
          name = 'buffer',
          option = {
            keyword_pattern = word_with_umlauts,
          },
        },
        { name = 'look' },
        { name = 'calc' },
        { name = 'path' },
        { name = 'spell' },
        { name = 'git' },
        {
          name = 'latex_symbols',
          option = {
            strategy = 1, -- show and insert the symbol
          },
        },
      },
    }
  end,
  config = function(_, opts)
    local cmp = require 'cmp'

    cmp.setup(opts)

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
        { name = 'cmdline_history' },
      }),
    })
  end,
}
