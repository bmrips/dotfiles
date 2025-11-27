return {
  'idanarye/nvim-impairative',
  event = 'VeryLazy',
  dependencies = 'jonatan-branting/nvim-better-n',
  opts = {
    enable = '[o',
    disable = ']o',
    toggle = 'yo',
    toggling = function(h)
      h:option {
        key = 'b',
        option = 'background',
        values = { [true] = 'light', [false] = 'dark' },
      }
      h:option {
        key = 'c',
        option = 'cursorline',
      }
      h:getter_setter {
        key = 'd',
        name = 'diff mode',
        get = function()
          return vim.o.diff
        end,
        set = function(value)
          if value then
            vim.cmd.diffthis()
          else
            vim.cmd.diffoff()
          end
        end,
      }
      h:option {
        key = 'h',
        option = 'hlsearch',
      }
      h:option {
        key = 'i',
        option = 'ignorecase',
      }
      h:option {
        key = 'l',
        option = 'list',
      }
      h:option {
        key = 'n',
        option = 'number',
      }
      h:option {
        key = 'r',
        option = 'relativenumber',
      }
      h:option {
        key = 's',
        option = 'spell',
      }
      h:option {
        key = 't',
        option = 'colorcolumn',
        values = { [true] = '+1', [false] = '' },
      }
      h:option {
        key = 'u',
        option = 'cursorcolumn',
      }
      h:option {
        key = 'v',
        option = 'virtualedit',
        values = { [true] = 'all', [false] = '' },
      }
      h:option {
        key = 'w',
        option = 'wrap',
      }
      h:getter_setter {
        key = 'W',
        name = "Vim's 'formatoptions=t' option",
        get = function()
          return vim.opt.formatoptions:get().t
        end,
        set = function(flag)
          if flag then
            vim.opt.formatoptions:prepend 't'
          else
            vim.opt.formatoptions:remove 't'
          end
        end,
      }
      h:getter_setter {
        key = 'x',
        name = "Vim's 'cursorline' and 'cursorcolumn' options both",
        get = function()
          return vim.o.cursorline and vim.o.cursorcolumn
        end,
        set = function(value)
          vim.o.cursorline = value
          vim.o.cursorcolumn = value
        end,
      }
    end,

    backward = '[',
    forward = ']',
    operations = function(h)
      h:text_manipulation {
        key = 'C',
        line_key = true,
        desc = '{Escape|Unescape} strings (C escape rules)',
        backward = require('impairative.helpers').encode_string,
        forward = require('impairative.helpers').decode_string,
      }
      h:function_pair {
        key = 'd',
        desc = '{Previous|Next} diagnostic',
        better_n = true,
        backward = function()
          vim.diagnostic.jump { count = -vim.v.count1 }
        end,
        forward = function()
          vim.diagnostic.jump { count = vim.v.count1 }
        end,
      }
      h:function_pair {
        key = 'D',
        desc = '{First|Last} diagnostic',
        backward = function()
          vim.diagnostic.jump { count = -math.huge, wrap = false }
        end,
        forward = function()
          vim.diagnostic.jump { count = math.huge, wrap = false }
        end,
      }
      h:function_pair {
        key = '<C-d>',
        desc = '{Previous|Next} error',
        better_n = true,
        backward = function()
          vim.diagnostic.jump { count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR }
        end,
        forward = function()
          vim.diagnostic.jump { count = vim.v.count1, severity = vim.diagnostic.severity.ERROR }
        end,
      }
      h:function_pair {
        key = 'e',
        desc = 'Exchange lines',
        forward = function()
          vim.cmd.move('+' .. tostring(vim.v.count1))
        end,
        backward = function()
          vim.cmd.move('-' .. tostring(vim.v.count1 + 1))
        end,
      }
      h:unified_function {
        key = 'f',
        desc = 'Jump to {previous|next} file in dir',
        better_n = true,
        fun = function(direction)
          local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1] or {}
          if win_info.quickfix == 1 then
            local cmd
            if win_info.loclist == 1 then
              if direction == 'backward' then
                cmd = 'lolder'
              else
                cmd = 'lnewer'
              end
            else
              if direction == 'backward' then
                cmd = 'colder'
              else
                cmd = 'cnewer'
              end
            end
            local ok, err = pcall(vim.cmd[cmd], {
              count = vim.v.count1,
            })
            if not ok then
              vim.api.nvim_echo(err, false, { err = true })
            end
          else
            local it = require('impairative.helpers').walk_files_tree(
              vim.fn.expand '%',
              direction == 'backward'
            )
            local path
            path = it:nth(vim.v.count1)
            if path then
              require('impairative.util').jump_to { filename = path }
            end
          end
        end,
      }
      h:jump_in_buf {
        key = 'n',
        desc = 'Jump to {previous|next} SCM conflict marker or diff/path hunk',
        better_n = true,
        extreme = {
          key = 'N',
          desc = 'Jump to {first|last} SCM conflict marker or diff/path hunk',
        },
        fun = require('impairative.helpers').conflict_marker_locations,
      }
      h:text_manipulation {
        key = 'u',
        line_key = true,
        desc = '{Encode|Decode} URL',
        backward = require('impairative.helpers').encode_url,
        forward = require('impairative.helpers').decode_url,
      }
      h:text_manipulation {
        key = 'x',
        line_key = true,
        desc = '{Encode|Decode} XML',
        backward = require('impairative.helpers').encode_xml,
        forward = require('impairative.helpers').decode_xml,
      }
      h:text_manipulation {
        key = 'y',
        line_key = true,
        backward = require('impairative.helpers').encode_string,
        desc = '{Escape|Unescape} strings (C escape rules)',
        forward = require('impairative.helpers').decode_string,
      }
    end,
  },
}
