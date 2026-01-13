return {
  'mfussenegger/nvim-lint',
  init = function()
    vim.api.nvim_create_autocmd(
      { 'BufWritePost', 'BufReadPost', 'BufModifiedSet', 'InsertLeave' },
      {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        desc = 'Invoke linters',
        callback = function()
          require('lint').try_lint(nil, { ignore_errors = true })
        end,
      }
    )
  end,
  opts = {
    editorconfig = { 'editorconfig-checker' },
    lua = { 'selene' },
    markdown = { 'markdownlint' },
    nix = { 'deadnix', 'statix' },
    yaml = { 'yamllint' },
    zsh = { 'zsh' },
  },
  config = function(_, opts)
    require('lint').linters_by_ft = opts
  end,
}
