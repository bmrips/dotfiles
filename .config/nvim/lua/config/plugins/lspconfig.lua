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
  marksman = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  },
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
