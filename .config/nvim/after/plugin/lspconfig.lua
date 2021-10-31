lspconfig = require("lspconfig")

-- Bash
lspconfig.bashls.setup {
  filetypes = { "bash", "sh" },
}

-- C, C++ and Objective C
lspconfig.clangd.setup {}

-- Haskell
lspconfig.hls.setup {
  root_dir = require('lspconfig/util').root_pattern(
    "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml", ".git"
  )
}

-- TeX
lspconfig.texlab.setup {
  settings = {
    texlab = {
      build = {
        args = {"-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f"},
        onSave = true,
      },
      forwardSearch = {
        executable = "okular",
        args = { "--unique", "file:%p#src:%l%f" },
      },
    },
  },
}
