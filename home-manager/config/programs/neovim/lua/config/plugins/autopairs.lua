return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    enable_bracket_in_quote = false,
    ignored_next_char = [=[[%w%%%'%[%"%.%`]]=],
  },
  config = function(_, opts)
    local autopairs = require 'nvim-autopairs'
    local ts_conds = require 'nvim-autopairs.ts-conds'
    autopairs.setup(opts)

    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    -- stylua: ignore
    autopairs.add_rules {
      Rule('$', '$', { 'markdown', 'tex' })
        :with_move(function(info)
          return info.char == '$' and info.next_char == info.rule.end_pair
        end),
      Rule('\\[', '\\]', 'tex')
        :with_pair(function(info)
          return info.line:sub(info.col-2, info.col-2) ~= '\\'
        end)
        :with_move(function(info)
          local followed_by_end_pair =
            vim.startswith(info.line:sub(info.col), info.rule.end_pair)
          return info.char == ']' and followed_by_end_pair
        end),
      Rule('= ', ';', 'nix')
        :with_pair(function(info)
          local prev_char = info.line:sub(info.col - 2, info.col - 2)
          local rest_of_line = info.line:sub(info.col)
          return prev_char:match('[^=<>!]') ~= nil
            and rest_of_line:match('^%s*$') ~= nil
            -- 'source': comments
            -- 'program': multi-line strings representing Bash scripts
            and ts_conds.is_not_ts_node{ 'source', 'string_fragment', 'program' }(info)
        end)
        :with_move(function(info)
          return info.char == ';'
        end),
      Rule('with ', ';', 'nix')
        :with_pair(function(info)
          local prev_char = info.line:sub(info.col - 5, info.col - 5)
          return prev_char:match('[^%w_-]') ~= nil
            -- 'source': comments
            -- 'program': multi-line strings representing Bash scripts
            and ts_conds.is_not_ts_node{ 'source', 'string_fragment', 'program' }(info)
        end)
        :with_move(function(info)
          return info.char == ';'
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
