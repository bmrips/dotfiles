local servers = {
  bashls = {
    settings = {
      ['bashIde.includeAllWorkspaceSymbols'] = true,
    },
    filetypes = { 'bash', 'sh' },
  },
  dartls = {},
  hls = {
    settings = {
      haskell = {
        formattingProvider = 'fourmolu',
        ['plugin.rename.config.diff'] = true, -- renaming across modules
      },
    },
  },
  jdtls = {},
  ltex_plus = {
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
        ['format.enable'] = false,
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
          executable = 'sioyek',
          args = {
            '--reuse-window',
            '--execute-command',
            'toggle_synctex',
            '--inverse-search',
            'texlab inverse-search -i "%%1" -l %%2',
            '--forward-search-file',
            '%f',
            '--forward-search-line',
            '%l',
            '%p',
          },
        },
      },
    },
  },
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
  {
    'neovim/nvim-lspconfig',
    event = 'FileType',
    cmd = {
      'LspInfo',
      'LspLog',
      'LspRestart',
      'LspStart',
      'LspStop',
    },
    dependencies = 'saghen/blink.cmp',
    config = function()
      local blink = require 'blink.cmp'
      local lspconfig = require 'lspconfig'
      for server, config in pairs(servers) do
        config.capabilities = blink.get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  { 'barreiroleo/ltex_extra.nvim' },
}
