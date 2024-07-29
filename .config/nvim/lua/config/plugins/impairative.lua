return {
  'idanarye/nvim-impairative',
  event = 'VeryLazy',
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
      h:getter_setter {
        key = 'e',
        name = 'inline diagnostics',
        get = function()
          return vim.diagnostic.config().virtual_lines or false
        end,
        set = function(flag)
          vim.diagnostic.config {
            virtual_text = not flag,
            virtual_lines = flag,
          }
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
      h:command_pair {
        key = 'a',
        backward = 'previous',
        forward = 'next',
      }
      h:command_pair {
        key = 'A',
        backward = 'first',
        forward = 'last',
      }
      h:command_pair {
        key = 'b',
        backward = 'bprevious',
        forward = 'bnext',
      }
      h:command_pair {
        key = 'B',
        backward = 'bfirst',
        forward = 'blast',
      }
      h:command_pair {
        key = 'b',
        backward = 'bprevious',
        forward = 'bnext',
      }
      h:text_manipulation {
        key = 'C',
        line_key = true,
        desc = '{escape|unescape} strings (C escape rules)',
        backward = require('impairative.helpers').encode_string,
        forward = require('impairative.helpers').decode_string,
      }
      h:function_pair {
        key = 'e',
        desc = 'exchange lines',
        forward = function()
          vim.cmd.move('+' .. tostring(vim.v.count1))
        end,
        backward = function()
          vim.cmd.move('-' .. tostring(vim.v.count1 + 1))
        end,
      }
      h:unified_function {
        key = 'f',
        desc = 'jump to the {previous|next} file in the directory tree',
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
            local ok, err = pcall(vim.cmd, {
              cmd = cmd,
              count = vim.v.count1,
            })
            if not ok then
              vim.api.nvim_err_writeln(err)
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
      h:command_pair {
        key = 'l',
        backward = 'lprevious',
        forward = 'lnext',
      }
      h:command_pair {
        key = 'L',
        backward = 'lfirst',
        forward = 'llast',
      }
      h:command_pair {
        key = '<C-l>',
        backward = 'lpfile',
        forward = 'lnfile',
      }
      h:jump_in_buf {
        key = 'n',
        desc = 'jump to the {previous|next} SCM conflict marker or diff/path hunk',
        extreme = {
          key = 'N',
          desc = 'jump to the {first|last} SCM conflict marker or diff/path hunk',
        },
        fun = require('impairative.helpers').conflict_marker_locations,
      }
      h:command_pair {
        key = 'q',
        backward = 'cprevious',
        forward = 'cnext',
      }
      h:command_pair {
        key = 'Q',
        backward = 'cfirst',
        forward = 'clast',
      }
      h:command_pair {
        key = '<C-q>',
        backward = 'cpfile',
        forward = 'cnfile',
      }
      h:command_pair {
        key = 't',
        backward = 'tprevious',
        forward = 'tnext',
      }
      h:command_pair {
        key = 'T',
        backward = 'tfirst',
        forward = 'tlast',
      }
      h:command_pair {
        key = '<C-t>',
        backward = 'ptprevious',
        forward = 'ptnext',
      }
      h:text_manipulation {
        key = 'u',
        line_key = true,
        desc = '{encode|decode} URL',
        backward = require('impairative.helpers').encode_url,
        forward = require('impairative.helpers').decode_url,
      }
      h:text_manipulation {
        key = 'x',
        line_key = true,
        desc = '{encode|decode} XML',
        backward = require('impairative.helpers').encode_xml,
        forward = require('impairative.helpers').decode_xml,
      }
      h:text_manipulation {
        key = 'y',
        line_key = true,
        backward = require('impairative.helpers').encode_string,
        desc = '{escape|unescape} strings (C escape rules)',
        forward = require('impairative.helpers').decode_string,
      }
      h:unified_function {
        key = '<Space>',
        desc = 'add blank line(s) {above|below} the current line',
        fun = function(direction)
          local line_number = vim.api.nvim_win_get_cursor(0)[1]
          if direction == 'backward' then
            line_number = line_number - 1
          end
          local lines = vim.fn['repeat']({ '' }, vim.v.count1)
          vim.api.nvim_buf_set_lines(0, line_number, line_number, true, lines)
        end,
      }
    end,
  },
}
