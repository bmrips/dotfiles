---@module 'lazy.types'
---@type LazyPluginSpec
return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  init = function()
    vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,

  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters = {
      jaq = {
        command = 'jaq',
        args = { '--sort-keys', '.' },
      },
      treefmt = {
        require_cwd = false,
      },
    },
    formatters_by_ft = {
      ['*'] = { 'keep-sorted', 'treefmt', 'trim_newlines', 'trim_whitespace' },
      bash = { 'shfmt' },
      dart = { 'dart_format' },
      haskell = { 'fourmolu' },
      json = { 'jaq' },
      lua = { 'stylua' },
      markdown = { 'markdownlint', 'mdformat' },
      nix = { 'nixfmt' },
      yaml = { 'yamlfmt' },
    },
  },
}
