return {
  'windwp/nvim-autopairs',
  opts = {
    enable_bracket_in_quote = false,
    ignored_next_char = [=[[%w%%%'%[%"%.%`]]=],
  },
  config = function(_, opts)
    local autopairs = require 'nvim-autopairs'
    autopairs.setup(opts)

    local Rule = require 'nvim-autopairs.rule'
    local ts_cond = require 'nvim-autopairs.ts-conds'
    -- stylua: ignore
    autopairs.add_rules {
      Rule('$', '$', { 'markdown', 'tex' })
        :with_pair(ts_cond.is_not_ts_node { 'comment' })
        :with_move(function(info)
          return info.char == '$' and info.line:sub(info.col, info.col) == '$'
        end),
      Rule('\\[', '\\]', 'tex')
        :with_pair(ts_cond.is_not_ts_node { 'comment' })
        :with_move(function(info)
          local followed_by_end_pair =
            vim.startswith(info.line:sub(info.col), info.rule.end_pair)
          return info.char == ']' and followed_by_end_pair
        end),
    }
  end,
}
