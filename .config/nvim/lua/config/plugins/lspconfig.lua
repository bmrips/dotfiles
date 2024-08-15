local servers = {
  bashls = {
    settings = {
      ['bashIde.includeAllWorkspaceSymbols'] = true,
    },
    filetypes = { 'bash', 'sh' },
  },
  digestif = {},
  hls = {
    settings = {
      haskell = {
        formattingProvider = 'fourmolu',
        ['plugin.rename.config.diff'] = true, -- renaming across modules
      },
    },
  },
  ltex = {
    filetypes = {
      -- 'bib',
      'gitcommit',
      'markdown',
      'org',
      'plaintex',
      'rst',
      'rnoweb',
      'tex',
      'pandoc',
      'quarto',
      'rmd',
      'context',
      'html',
      'xhtml',
    },
    on_attach = function()
      require('ltex_extra').setup {
        load_langs = { 'en-US', 'de-DE' },
        path = '.ltex',
      }
    end,
    settings = {
      ltex = {
        language = 'en-GB',
        ['additionalRules.enablePickyRules'] = true,
        completionEnabled = true,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        ['diagnostics.globals'] = { 'vim' },
        ['format.enable'] = false,
        ['runtime.version'] = 'LuaJIT', -- the Lua version
      },
    },
  },
  nil_ls = {
    settings = {
      ['nil.formatting.command'] = { 'nixfmt' },
    },
  },
  texlab = {
    settings = {
      texlab = {
        -- Build with LuaLaTeX.
        build = {
          args = { '-lualatex', '-interaction=nonstopmode', '-synctex=1', '%f' },
        },
        forwardSearch = {
          executable = 'okular',
          args = { '--unique', 'file:%p#src:%l%f' },
        },
      },
    },
  },
  -- vale_ls = {},
  yamlls = {
    settings = {
      ['yaml.schemas'] = {
        kubernetes = '*.{yml,yaml}',
        ['https://raw.githubusercontent.com/cmhughes/latexindent.pl/main/documentation/latexindent-yaml-schema.json'] = 'latexindent.yaml',
      },
    },
  },
}

return {
  'neovim/nvim-lspconfig',
  event = 'FileType',
  cmd = {
    'LspInfo',
    'LspLog',
    'LspRestart',
    'LspStart',
    'LspStop',
  },
  dependencies = {
    {
      'barreiroleo/ltex-extra.nvim',
      event = 'LspAttach',
    },
    {
      'hrsh7th/cmp-nvim-lsp',
      event = 'LspAttach',
    },
  },
  opts = servers,
  config = function(_, opts)
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require 'lspconfig'
    for server, config in pairs(opts) do
      config.capabilities = capabilities
      lspconfig[server].setup(config)
    end
  end,
}
