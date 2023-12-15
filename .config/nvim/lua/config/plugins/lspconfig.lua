local servers = {
  bashls = {
    settings = {
      bashIde = {
        includeAllWorkspaceSymbols = true,
      },
    },
    filetypes = { 'bash', 'sh' },
  },
  clangd = {},
  elixirls = {
    cmd = { '/usr/lib/elixir-ls/language_server.sh' },
  },
  hls = {
    settings = {
      haskell = {
        formattingProvider = 'fourmolu',
      },
    },
  },
  jdtls = {},
  ltex = {
    filetypes = { -- without bib
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
    },
    on_attach = function()
      require('ltex_extra').setup {
        load_langs = { 'en-US', 'de-DE' },
      }
    end,
    settings = {
      ltex = {
        language = 'en-GB',
        additionalRules = {
          enablePickyRules = true,
        },
      },
    },
  },
  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if
        not vim.loop.fs_stat(path .. '/.luarc.json')
        and not vim.loop.fs_stat(path .. '/.luarc.jsonc')
      then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            runtime = {
              version = 'LuaJIT',
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file('', true),
              },
            },
          },
        })

        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end
      return true
    end,
  },
  marksman = {},
  pkgbuild_language_server = {},
  texlab = {
    settings = {
      texlab = {
        build = {
          -- Build with LuaLaTeX.
          args = { '-lualatex', '-interaction=nonstopmode', '-synctex=1', '%f' },
        },
        forwardSearch = {
          executable = 'okular',
          args = { '--unique', 'file:%p#src:%l%f' },
        },
      },
    },
  },
  taplo = {},
}

-- On a Nix installation, the jdtls binary is named `jdt-language-server`.
if vim.fn.executable 'jdt-language-server' == 1 then
  local jdtls_cache = vim.env.XDG_CACHE_HOME .. '/jdtls'

  servers.jdtls.cmd = {
    'jdt-language-server',
    '-configuration',
    jdtls_cache .. '/config',
    '-data',
    jdtls_cache .. '/workspace',
  }
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'barreiroleo/ltex-extra.nvim',
    'folke/neodev.nvim',
    'hrsh7th/cmp-nvim-lsp',
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
