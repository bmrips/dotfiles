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
      treefmt = {
        -- Disable treefmt for Haskell files since fourmolu requires the
        -- original path to determine the active language extensions but only
        -- gets conform's temporary path.
        condition = function(_self, ctx)
          return not vim.endswith(ctx.filename, '.hs')
        end,
        require_cwd = false,
      },
    },
    formatters_by_ft = {
      ['*'] = { 'keep-sorted', 'treefmt', 'trim_newlines', 'trim_whitespace' },
      bash = { 'shfmt' },
      dart = { 'dart_format' },
      haskell = { 'fourmolu' },
      json = { 'jq' },
      lua = { 'stylua' },
      markdown = { 'markdownlint', 'mdformat' },
      nix = { 'nixfmt' },
      yaml = { 'yamlfmt' },
    },
  },
}
