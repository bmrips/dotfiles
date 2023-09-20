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
    local cond = require 'nvim-autopairs.conds'
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

    -- When typing a space, insert a pair of spaces in specified pairs
    local pairs_obeying_space = {
      ['$'] = '$',
      ['('] = ')',
      ['['] = ']',
      ['\\['] = '\\]',
      ['{'] = '}',
    }

    -- stylua: ignore
    autopairs.add_rules {
      Rule(' ', ' ')
        :with_pair(function(info)
          for begin_pair, end_pair in pairs(pairs_obeying_space) do
            local left = info.line:sub(1, info.col-1)
            local right = info.line:sub(info.col)
            if vim.endswith(left, begin_pair) and vim.startswith(right, end_pair) then
              return true
            end
          end
          return false
        end)
    }

    -- stylua: ignore
    for begin_pair, end_pair in pairs(pairs_obeying_space) do
      autopairs.add_rules {
        Rule(begin_pair..' ', ' '..end_pair)
          :with_pair(cond.none())
          :with_move(function(info)
            return vim.startswith(info.line:sub(info.col), info.rule.end_pair)
          end)
          :with_del(cond.none())
          :use_key(end_pair:sub(-1))
      }
    end
  end,
}
