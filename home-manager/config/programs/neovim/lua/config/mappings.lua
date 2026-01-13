-- stylua: ignore
return {
  init = {
    { '<BS>',
      function()
        vim.cmd.nohlsearch()
        vim.cmd.diffupdate()
        vim.cmd.mode() -- clear and redraw the screen
        Snacks.notifier.hide()
      end,
      desc = 'Clear screen and redraw',
    },
    { '<CR>',
      function()
        local type = vim.opt_local.buftype:get()
        if type == 'quickfix' or type == 'prompt' or type == 'nofile' then
          return '<CR>'
        else
          return '<C-^>'
        end
      end,
      desc = 'Switch to alternate buffer',
      expr = true,
    },
    { '<Tab>',
      function()
        require('fold-cycle').open()
      end,
      desc = 'Open folds under cursor',
    },
    { '<S-Tab>',
      function()
        require('fold-cycle').close()
      end,
      desc = 'Close folds under cursor',
    },
    { '<Down>',
      'j',
      mode = { 'n', 'o', 'x' },
      remap = true,
    },
    { '<Up>',
      'k',
      mode = { 'n', 'o', 'x' },
      remap = true,
    },
    { 'g', {
      { 'a',
        '<Plug>(EasyAlign)',
        desc = 'Align',
        mode = { 'n', 'o', 'x' },
        remap = true,
      },
      { 'l',
        function()
          return require('pantran').motion_translate()
        end,
        desc = 'Translate',
        expr = true,
        mode = { 'n', 'o', 'x' },
      },
      { 'L',
        function()
          return require('pantran').motion_translate() .. '_'
        end,
        desc = 'Translate',
        expr = true,
      },
      { 's',
        [[:%s/\v\C<<C-r><C-w>>//g<Left><Left>]],
        desc = 'Substitute word under cursor',
      },
      { 'S',
        [[:%s/\v/g<Left><Left>]],
        desc = 'Substitute pattern',
      },
      { 'S',
        [[:s/\v/g<Left><Left>]],
        desc = 'Substitute pattern',
        mode = 'x',
      },
      { 'o',
        function()
          vim.g.operatorfunc = function()
            local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, '['))
            local stop_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ']'))
            vim.cmd.sort {
              args = { 'i' },
              range = { start_row, stop_row },
            }
          end

          vim.opt.operatorfunc = 'v:lua.vim.g.operatorfunc'
          return 'g@'
        end,
        desc = 'Sort',
        expr = true,
      },
      { 'o',
        ':sort i<CR>',
        desc = 'Sort',
        mode = 'x',
      },
      { 'O',
        ':sort i',
        desc = 'Sort with options',
        mode = 'x',
      },
      { '/',
        ':sil gr! <C-R><C-w><CR>',
        desc = 'Grep word under cursor',
      },
      { '<C-', {
        { 'a>',
          function()
            require('dial.map').manipulate('increment', 'gnormal')
          end,
          desc = 'Increment stepwise',
        },
        { 'a>',
          function()
            require('dial.map').manipulate('increment', 'gvisual')
          end,
          desc = 'Increment stepwise',
          mode = 'x',
        },
        { 'j>',
          function()
            require('treesj').toggle()
          end,
          desc = 'Split/join blocks of code',
        },
        { 'x>',
          function()
            require('dial.map').manipulate('decrement', 'gnormal')
          end,
          desc = 'Decrement stepwise',
        },
        { 'x>',
          function()
            require('dial.map').manipulate('decrement', 'gvisual')
          end,
          desc = 'Decrement stepwise',
          mode = 'x',
        },
      }},
    }},
    { 'H',
      '^',
      mode = { 'n', 'o', 'x' },
      desc = 'Start of line (non ws)',
    },
    { 'j',
      'v:count == 0 ? "gj" : "j"',
      desc = 'Line down',
      expr = true,
      mode = { 'n', 'x' },
    },
    { 'k',
      'v:count == 0 ? "gk" : "k"',
      desc = 'Line up',
      expr = true,
      mode = { 'n', 'x' },
    },
    { 'L',
      '$',
      mode = { 'n', 'o', 'x' },
      desc = 'End of line',
    },
    { 'm', {
      { '<CR>',
        '<Cmd>make!<CR>',
        desc = 'Make',
      },
      { '<Space>',
        ':<C-U>make!<Space>',
        desc = 'Make given target',
      },
    }},
    { 's',
      function()
        require('leap').leap {
          target_windows = { vim.api.nvim_get_current_win() },
        }
      end,
      desc = 'Leap',
      mode = { 'n', 'x', 'o' },
    },
    { 'S',
      function ()
        require('leap').leap {
          target_windows = require('leap.util').get_enterable_windows(),
        }
      end,
      desc = 'Leap outside',
      mode = { 'n', 'x', 'o' },
    },
    { 'U',
      function()
        require('undotree').toggle()
      end,
      desc = 'Open undo tree',
    },
    { 'y',
      'ygv<Esc>',
      desc = 'Yank',
      mode = 'x',
    },
    { 'z', {
      { 'A',
        function()
          require('fold-cycle').toggle_all()
        end,
        desc = 'Toggle all folds under cursor',
        remap = true,
      },
      { 'C',
        function()
          require('fold-cycle').close_all()
        end,
        desc = 'Close all folds under cursor',
        remap = true,
      },
      { 'F',
        -- selene: allow(bad_string_escape)
        '":Fold ".v:count." | silent! call repeat#set(\"zF\", ".v:count.")<CR>"',
        desc = 'Create fold of given level',
        expr = true,
        mode = { 'n', 'o', 'x' },
      },
      { 'O',
        function()
          require('fold-cycle').open_all()
        end,
        desc = 'Open all folds under cursor',
        remap = true,
      },
    }},
    { '<A-', {
      { 'c>',
        '<Cmd>tabclose<CR>',
        desc = 'Close tab',
      },
      { 'h>',
        '"<Cmd>silent! tabmove ".(tabpagenr()-2)."<CR>"',
        desc = 'Move tab left',
        expr = true,
      },
      { 'j>',
        '<Cmd>tabnext<CR>',
        desc = 'Next tab',
      },
      { 'k>',
        '<Cmd>tabprev<CR>',
        desc = 'Previous tab',
      },
      { 'l>',
        '"<Cmd>silent! tabmove ".(tabpagenr()+1)."<CR>"',
        desc = 'Move tab right',
        expr = true,
      },
      { 'n>',
        '<Cmd>tabnew<CR>',
        desc = 'New tab',
      },
      { 'o>',
        '<Cmd>tabonly<CR>',
        desc = 'Close all other tabs',
      },
      { 'Tab>',
        'g<Tab>',
        desc = 'Go to alternate tab',
      },
    }},
    { '<C-', {
      { 'Left>',
        function()
          require('smart-splits').resize_left()
        end,
        desc = 'Decrease window width',
      },
      { 'Down>',
        function()
          require('smart-splits').resize_down()
        end,
        desc = 'Decrease window height',
      },
      { 'Up>',
        function()
          require('smart-splits').resize_up()
        end,
        desc = 'Increase window height',
      },
      { 'Right>',
        function()
          require('smart-splits').resize_right()
        end,
        desc = 'Increase window width',
      },
      { 'a>',
        function()
          require('dial.map').manipulate('increment', 'normal')
        end,
        desc = 'Increment',
      },
      { 'a>',
        function()
          require('dial.map').manipulate('increment', 'visual')
        end,
        desc = 'Increment',
        mode = 'x',
      },
      { 'c>',
        'ciw',
        desc = 'Change word under cursor',
      },
      { 'g>',
        function() Snacks.picker.grep_word() end,
        desc = 'Grep visual selection',
        mode = 'x',
      },
      { 'h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
        desc = 'Go to left window',
      },
      { 'j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
        desc = 'Go to down window',
      },
      { 'k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
        desc = 'Go to up window',
      },
      { 'l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
        desc = 'Go to right window',
      },
      { 'p>',
        '<C-i>',
        desc = 'Go forward in jump list',
        mode = { 'n', 'o', 'x' },
      },
      { 'q>',
        '<Cmd>wincmd q<CR>',
        desc = 'Quit the window'
      },
      { 's>',
        '<ESC>:w<CR>',
        desc = 'Save the buffer',
        mode = { 'n', 'i' },
      },
      { 'w>', {
        { '<CR>',
          '<Cmd>wincmd ^<CR>',
          desc = 'Open alternate buffer in split',
        },
        { '}',
          '<Cmd>tab wincmd ]<CR>',
          desc = 'Jump to tag in tab split',
        },
        { 'a',
          '<Cmd>wincmd ^<CR>',
          desc = 'Open alternate buffer in split',
        },
        { 'A',
          '<Cmd>tab wincmd ^<CR>',
          desc = 'Open alternate buffer in tab split',
        },
        { 'D',
          '<Cmd>tab wincmd d<CR>',
          desc = 'Open definition in tab split',
        },
        { 'F',
          '<Cmd>tab wincmd f<CR>',
          desc = 'Open file in tab split',
        },
        { 'I',
          '<Cmd>tab wincmd i<CR>',
          desc = 'Open import in tab split',
        },
        { 'm',
          '<Cmd>WinShift<CR>',
          desc = 'Move interactively',
        },
        { 'X',
          '<Cmd>WinShift swap<CR>',
          desc = 'Swap interactively',
        },
        { '<C-', {
          { ']>',
            '<Cmd>vertical wincmd ]<CR>',
            desc = 'Jump to tag in vert split',
          },
          { 'a>',
            '<Cmd>vertical wincmd ^<CR>',
            desc = 'Open alternate buffer in vert split',
          },
          { 'd>',
            '<Cmd>vertical wincmd d<CR>',
            desc = 'Open definition in vert split',
          },
          { 'f>',
            '<Cmd>vertical wincmd f<CR>',
            desc = 'Open file in vert split',
          },
          { 'i>',
            '<Cmd>vertical wincmd i<CR>',
            desc = 'Open import in vert split',
          },
        }},
      }},
      { 'x>',
        function()
          require('dial.map').manipulate('decrement', 'normal')
        end,
        desc = 'Decrement',
      },
      { 'x>',
        function()
          require('dial.map').manipulate('decrement', 'visual')
        end,
        desc = 'Decrement',
        mode = 'x',
      },
    }},
    { '<Leader>', {
      { 'd',
        function() Snacks.bufdelete.delete() end,
        desc = 'Delete the buffer',
      },
      { 'e',
        function() Snacks.explorer.open() end,
        desc = 'Toggle explorer',
      },
      { 'g', {
        {
          'i',
          function() Snacks.picker.gh_issue() end,
          desc = 'GitHub Issues (open)',
        },
        {
          'I',
          function() Snacks.picker.gh_issue { state = 'all' } end,
          desc = 'GitHub Issues (all)',
        },
        {
          'p',
          function() Snacks.picker.gh_pr() end,
          desc = 'GitHub Pull Requests (open)',
        },
        {
          'P',
          function() Snacks.picker.gh_pr { state = 'all' } end,
          desc = 'GitHub Pull Requests (all)',
        },
      }},
      { 'i',
        function()
          local normalizedNameUnderCursor = vim.fs.normalize(vim.fn.expand('<cfile>'))
          local file = vim.fn.findfile(normalizedNameUnderCursor)
          vim.fn.append('.', vim.fn.readfile(file))
          vim.cmd.delete()
        end,
        desc = 'Include file under cursor',
      },
      { 'n',
        function() Snacks.notifier.show_history() end,
        desc = 'Notification history',
      },
      { 'p',
        function()
          require('lazy').home()
        end,
        desc = 'Plugins',
      },
      { 's',
        function()
          require('session').toggleAutosave()
        end,
        desc = 'Toggle session autosave',
      },
      { 'x',
        '<Cmd>x<CR>',
        desc = 'Exit',
      },
      { '.',
        function() Snacks.scratch() end,
        desc = 'Toggle scratch buffer',
      },
    }},
    { '<LocalLeader>', {
      { 'd',
        function()
          require('trouble.api').toggle 'diagnostics'
        end,
        desc = 'Diagnostics',
      },
      { 'e',
        vim.diagnostic.open_float,
        desc = 'Show diagnostics under cursor',
      },
      { 'f',
        function()
          require('conform').format()
        end,
        desc = 'Format buffer',
        mode = { 'n', 'o', 'x' },
      },
      { 'v',
        function()
          local is_running = require('livepreview').is_running()
          vim.cmd.LivePreview(is_running and 'close' or 'start')
        end,
        desc = 'View document in the browser',
      },
      { '<C-d>',
        function() Snacks.picker.diagnostics() end,
        desc = 'Diagnostics (fuzzy)',
      },
    }},
    { ';',
      ':',
      desc = 'Command mode',
      mode = { 'n', 'o', 'x' },
    },
    { ',', {
      { '<Space>',
        function() Snacks.picker.pickers() end,
        desc = 'Pickers',
      },
      { ',',
        function()
          Snacks.picker.resume {
            exclude = {
              'lsp_declarations',
              'lsp_definitions',
              'lsp_implementations',
              'lsp_type_definitions',
            },
          }
        end,
        desc = 'Resume'
      },
      { ':',
        function() Snacks.picker.command_history() end,
        desc = 'Command history',
      },
      { '/',
        function() Snacks.picker.search_history() end,
        desc = 'Search history',
      },
      { '?',
        function() Snacks.picker.search_history() end,
        desc = 'Search history',
      },
      { 'a',
        function() Snacks.picker 'arguments' end,
        desc = 'Arguments',
      },
      { 'A',
        function() Snacks.picker.autocmds() end,
        desc = 'Autocmds',
      },
      { 'b',
        function() Snacks.picker.buffers() end,
        desc = 'Buffers',
      },
      { 'c',
        function() Snacks.picker.commands() end,
        desc = 'Commands',
      },
      { 'C',
        function() Snacks.picker.colorschemes() end,
        desc = 'Colorschemes',
      },
      { 'f',
        function() Snacks.picker.files() end,
        desc = 'Files',
      },
      { 'F',
        function() Snacks.picker.git_files() end,
        desc = 'Git-tracked files',
      },
      { '<C-f>',
        function() Snacks.picker.recent() end,
        desc = 'Recent files',
      },
      { 'g',
        function() Snacks.picker.grep() end,
        desc = 'Grep',
      },
      { '<C-g>',
        function()
          Snacks.picker.resume {
            include = { 'grep', 'grep_word' },
          }
        end,
        desc = 'Git grep',
      },
      { 'h',
        function() Snacks.picker.help() end,
        desc = 'Help tags',
      },
      { 'H',
        function() Snacks.picker.man() end,
        desc = 'Man pages',
      },
      { 'i',
        function() Snacks.picker.icons() end,
        desc = 'Icons',
      },
      { 'j',
        function() Snacks.picker.jumps() end,
        desc = 'Jumps',
      },
      { 'k',
        function() Snacks.picker.keymaps() end,
        desc = 'Keymaps',
      },
      { 'l',
        function() Snacks.picker.lines() end,
        desc = 'Buffer lines',
      },
      { 'L',
        function() Snacks.picker.grep_buffers() end,
        desc = 'Current buffer lines',
      },
      { 'm',
        function() Snacks.picker.marks() end,
        desc = 'Marks',
      },
      { 'n',
        function() Snacks.picker.notifications() end,
        desc = 'Notifications',
      },
      { 'q',
        function() Snacks.picker.qflist() end,
        desc = 'Quickfix list',
      },
      { 'Q',
        function() Snacks.picker.loclist() end,
        desc = 'Location list',
      },
      { 'r',
        function() Snacks.picker.registers() end,
        desc = 'Registers',
      },
      { 's',
        function() Snacks.scratch.select() end,
        desc = 'Select scratch buffer',
      },
      { 't',
        function() Snacks.picker 'filetypes' end,
        desc = 'Filetypes',
      },
      { 'T',
        function() Snacks.picker 'todo_comments' end,
        desc = 'Todos',
      },
      { 'u',
        function() Snacks.picker.undo() end,
        desc = 'Undo history',
      },
      { 'w',
        function() Snacks.picker.grep_word() end,
        desc = 'Grep word under cursor',
      },
    }},

    { mode = 'i', {
      { '<Down>',
        '<C-o>gj',
      },
      { '<Up>',
        '<C-o>gk',
      },
      { 'jk',
        '<Esc>',
        desc = 'Escape insert mode',
      },
    }},

    { mode = 'c', '<C-', {
      { 'j>',
        '<Down>',
        desc = 'Recall newer cmdline with matching beginning',
      },
      { 'k>',
        '<Up>',
        desc = 'Recall older cmdline with matching beginning',
      },
    }},
  },
  lsp = function(client_supports) -- Adapt the keymaps to the client's capabilities
    return {
      { 'g', {
        { 'd',
          function()
            Snacks.picker.lsp_definitions {
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition',
        },
        { 'D',
          function()
            Snacks.picker.lsp_declarations {
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'declarationProvider',
          desc = 'Goto declaration',
        },
        { 'i',
          function()
            Snacks.picker.lsp_implementations {
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation',
        },
        { 'r',
          vim.lsp.buf.rename,
          cond = client_supports 'renameProvider',
          desc = 'Rename',
          nowait = true, -- to override Neovim's default-mappings
        },
        { 't',
          function()
            Snacks.picker.lsp_type_definitions {
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition',
        },
      }},
      { 'K',
        vim.lsp.buf.hover,
        cond = client_supports 'hoverProvider',
        desc = 'Hover',
      },
      { '<C-k>',
        vim.lsp.buf.signature_help,
        cond = client_supports 'signatureHelpProvider',
        desc = 'Show signature',
        mode = { 'i', 's' },
      },
      { '<C-w>', {
        { 'd',
          function()
            Snacks.picker.lsp_definitions {
              confirm = 'qflist_or_split',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (split)',
        },
        { 'D',
          function()
            Snacks.picker.lsp_declarations {
              confirm = 'qflist_or_split',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (tab split)',
        },
        { '<C-d>',
          function()
            Snacks.picker.lsp_definitions {
              confirm = 'qflist_or_vsplit',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (vsplit)',
        },
        { 'i',
          function()
            Snacks.picker.lsp_implementations {
              confirm = 'qflist_or_split',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (split)',
        },
        { 'I',
          function()
            Snacks.picker.lsp_implementations {
              confirm = 'qflist_or_tab',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (tab split)',
        },
        { '<C-i>',
          function()
            Snacks.picker.lsp_implementations {
              confirm = 'qflist_or_vsplit',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (vsplit)',
        },
        { 't',
          function()
            Snacks.picker.lsp_type_definitions {
              confirm = 'qflist_or_split',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (split)',
        },
        { 'T',
          function()
            Snacks.picker.lsp_type_definitions {
              confirm = 'qflist_or_tab',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (tab split)',
        },
        { '<C-t>',
          function()
            Snacks.picker.lsp_type_definitions {
              confirm = 'qflist_or_vsplit',
              unique_lines = vim.bo.filetype == 'lua',
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (vsplit)',
        },
      }},
      { '<LocalLeader>', {
        { 'a',
          vim.lsp.buf.code_action,
          cond = client_supports 'codeActionProvider',
          desc = 'Invoke a code action',
          mode = { 'n', 'o', 'x' },
        },
        { 'c', {
          { 'i',
            function() Snacks.picker.lsp_incoming_calls() end,
            cond = client_supports 'incomingCallsProvider',
            desc = 'Incoming calls',
          },
          { 'o',
            function() Snacks.picker.lsp_outgoing_calls() end,
            cond = client_supports 'outgoindCallsProvider',
            desc = 'Outgoing calls',
          },
        }},
        { 'o',
          function()
            require('aerial').toggle()
          end,
          desc = 'Toggle outline',
        },
        { 'q',
          function()
            require('trouble.api').toggle 'loclist'
          end,
          desc = 'Location list',
        },
        { 'Q',
          function()
            require('trouble.api').toggle 'qflist'
          end,
          desc = 'Quickfix list',
        },
        { 'r',
          function() Snacks.picker.lsp_references() end,
          cond = client_supports 'referencesProvider',
          desc = 'References',
        },
        { 's',
          function() Snacks.picker.lsp_workspace_symbols() end,
          cond = client_supports 'workspaceSymbolProvider',
          desc = 'Workspace symbols',
        },
        { 'S',
          function() Snacks.picker.lsp_symbols() end,
          cond = client_supports 'documentSymbolProvider',
          desc = 'Document symbols',
        },
        { 't',
          function()
            require('trouble.api').toggle 'symbols'
          end,
          desc = 'Symbols',
        },
        { 'T',
          function()
            require('trouble.api').toggle 'lsp'
          end,
          desc = 'All LSP locations',
        },
      }},
    }
  end,
}
