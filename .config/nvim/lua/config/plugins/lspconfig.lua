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
        formattingProvider = 'stylish-haskell',
      },
    },
  },
  jdtls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
  marksman = {},
  texlab = {
    settings = {
      texlab = {
        build = {
          -- Build with LuaLaTeX.
          args = { '-lualatex', '-interaction=nonstopmode', '-synctex=1', '%f' },
          onSave = true,
        },
        forwardSearch = {
          executable = 'okular',
          args = { '--unique', 'file:%p#src:%l%f' },
        },
      },
    },
  },
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
  dependencies = 'folke/neodev.nvim',
  opts = servers,
  config = function(_, opts)
    for server, config in pairs(opts) do
      require('lspconfig')[server].setup(config)
    end
  end,
}
