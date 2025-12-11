return {
  settings = {
    Lua = {
      completion = {
        autoRequire = false,
      },
      format = {
        enable = false,
        callSnippet = true,
      },
      -- runtime = {
      --   version = 'LuaJIT',
      --   requirePattern = {
      --     'lua/?.lua',
      --     'lua/?/init.lua',
      --     '?/lua/?.lua',
      --     '?/lua/?/init.lua',
      --   },
      -- },
      strict = {
        requirePath = true,
        typeCall = true,
        arrayIndex = true,
      },
    },
  },
}
