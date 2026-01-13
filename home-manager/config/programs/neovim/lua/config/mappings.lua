-- stylua: ignore
return {
  init = {
    { '<BS>',
      function()
        vim.cmd.nohlsearch()
        vim.cmd.diffupdate()
        vim.cmd.mode() -- clear and redraw the screen
        require('notify').dismiss {
          pending = false,
          silent = true,
        }
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
        function()
          require('fzf-lua').grep_visual()
        end,
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
        '<Cmd>bdelete<CR>',
        desc = 'Delete the buffer'
      },
      { 'i',
        function()
          local normalizedNameUnderCursor = vim.fs.normalize(vim.fn.expand('<cfile>'))
          local file = vim.fn.findfile(normalizedNameUnderCursor)
          vim.fn.append('.', vim.fn.readfile(file))
          vim.cmd.delete()
        end,
        desc = 'Include file under cursor',
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
      { '<C-d>',
        function()
          require('fzf-lua').diagnostics_workspace()
        end,
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
        function()
          require('fzf-lua').builtin()
        end,
      },
      { ',',
        function()
          require('fzf-lua').resume()
        end,
        desc = 'Resume'
      },
      { ':',
        function()
          require('fzf-lua').command_history()
        end,
        desc = 'Command history',
      },
      { '/',
        function()
          require('fzf-lua').search_history()
        end,
        desc = 'Search history',
      },
      { '?',
        function()
          require('fzf-lua').search_history()
        end,
        desc = 'Search history',
      },
      { 'a',
        function()
          require('fzf-lua').args()
        end,
        desc = 'Arguments',
      },
      { 'A',
        function()
          require('fzf-lua').autocmds()
        end,
        desc = 'Autocmds',
      },
      { 'b',
        function()
          require('fzf-lua').buffers()
        end,
        desc = 'Buffers',
      },
      { 'c',
        function()
          require('fzf-lua').commands()
        end,
        desc = 'Commands',
      },
      { 'C',
        function()
          require('fzf-lua').colorschemes()
        end,
        desc = 'Colorschemes',
      },
      { 'f',
        function()
          require('fzf-lua').files()
        end,
        desc = 'Files',
      },
      { 'F',
        function()
          require('fzf-lua').git_files()
        end,
        desc = 'Git-tracked files',
      },
      { '<C-f>',
        function()
          require('fzf-lua').oldfiles()
        end,
        desc = 'Recent Files',
      },
      { 'g',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = 'Grep',
      },
      { 'G',
        function()
          require('fzf-lua').live_grep_glob()
        end,
        desc = 'Grep with --glob',
      },
      { '<C-g>',
        function()
          require('fzf-lua').live_grep { resume = true }
        end,
        desc = 'Resume last grep',
      },
      { 'h',
        function()
          require('fzf-lua').help_tags()
        end,
        desc = 'Help tags',
      },
      { 'H',
        function()
          require('fzf-lua').man_pages()
        end,
        desc = 'Man pages',
      },
      { 'j',
        function()
          require('fzf-lua').jumps()
        end,
        desc = 'Jumps',
      },
      { 'k',
        function()
          require('fzf-lua').keymaps()
        end,
        desc = 'Keymaps',
      },
      { 'l',
        function()
          require('fzf-lua').lines()
        end,
        desc = 'Buffer lines',
      },
      { 'L',
        function()
          require('fzf-lua').blines()
        end,
        desc = 'Current buffer lines',
      },
      { 'm',
        function()
          require('fzf-lua').marks()
        end,
        desc = 'Marks',
      },
      { 'o',
        function()
          require('fzf-lua').grep_cword()
        end,
        desc = 'Grep word under cursor',
      },
      { 'O',
        function()
          require('fzf-lua').grep_cWORD()
        end,
        desc = 'Grep WORD under cursor',
      },
      { 'q',
        function()
          require('fzf-lua').quickfix()
        end,
        desc = 'Quickfix list',
      },
      { 'Q',
        function()
          require('fzf-lua').loclist()
        end,
        desc = 'Location list',
      },
      { 'r',
        function()
          require('fzf-lua').registers()
        end,
        desc = 'Registers',
      },
      { 's',
        function()
          require('fzf-lua').spell_suggest()
        end,
        desc = 'Spelling suggestions',
      },
      { 't',
        function()
          require('fzf-lua').filetypes()
        end,
        desc = 'Filetypes',
      },
      { 'T',
        function()
          require('fzf-lua').tagstack()
        end,
        desc = 'Tags',
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
      { '<C-f>',
        function()
          require('fzf-lua').complete_path()
        end,
        desc = 'Complete file names',
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
            vim.lsp.buf.definition {
              on_list = require('util.lsp.goto')(),
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition',
        },
        { 'D',
          function()
            vim.lsp.buf.declaration {
              on_list = require('util.lsp.goto')(),
            }
          end,
          cond = client_supports 'declarationProvider',
          desc = 'Goto declaration',
        },
        { 'i',
          function()
            vim.lsp.buf.implementation {
              on_list = require('util.lsp.goto')(),
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation',
        },
        { 't',
          function()
            vim.lsp.buf.type_definition {
              on_list = require('util.lsp.goto')(),
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
            vim.lsp.buf.definition {
              on_list = require('util.lsp.goto')('split'),
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (split)',
        },
        { 'D',
          function()
            vim.lsp.buf.definition {
              on_list = require('util.lsp.goto')('tab split'),
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (tab split)',
        },
        { '<C-d>',
          function()
            vim.lsp.buf.definition {
              on_list = require('util.lsp.goto')('vert split'),
            }
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Goto definition (vsplit)',
        },
        { 'i',
          function()
            vim.lsp.buf.implementation {
              on_list = require('util.lsp.goto')('split'),
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (split)',
        },
        { 'I',
          function()
            vim.lsp.buf.implementation {
              on_list = require('util.lsp.goto')('tab split'),
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (tab split)',
        },
        { '<C-i>',
          function()
            vim.lsp.buf.implementation {
              on_list = require('util.lsp.goto')('vert split'),
            }
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Goto implementation (vsplit)',
        },
        { 't',
          function()
            vim.lsp.buf.type_definition {
              on_list = require('util.lsp.goto')('split'),
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (split)',
        },
        { 'T',
          function()
            vim.lsp.buf.type_definition {
              on_list = require('util.lsp.goto')('tab split'),
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (tab split)',
        },
        { '<C-t>',
          function()
            vim.lsp.buf.type_definition {
              on_list = require('util.lsp.goto')('vert split'),
            }
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Goto type definition (vsplit)',
        },
      }},
      { '<LocalLeader>', {
        { '/',
          function()
            require('fzf-lua').lsp_finder()
          end,
          desc = 'All LSP locations',
        },
        { 'a',
          vim.lsp.buf.code_action,
          cond = client_supports 'codeActionProvider',
          desc = 'Invoke a code action',
          mode = { 'n', 'o', 'x' },
        },
        { 'c', {
          { 'i',
            vim.lsp.buf.incoming_calls,
            cond = client_supports 'incomingCallsProvider',
            desc = 'List incoming calls',
          },
          { 'o',
            vim.lsp.buf.outgoing_calls,
            cond = client_supports 'outgoingCallsProvider',
            desc = 'List outgoing calls',
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
          vim.lsp.buf.rename,
          cond = client_supports 'renameProvider',
          desc = 'Rename symbol under cursor',
        },
        { 's',
          vim.lsp.buf.workspace_symbol,
          cond = client_supports 'workspaceSymbolProvider',
          desc = 'List all workspace symbols',
        },
        { 'S',
          vim.lsp.buf.document_symbol,
          cond = client_supports 'documentSymbolProvider',
          desc = 'List all document symbols',
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
        { 'u',
          vim.lsp.buf.references,
          cond = client_supports 'referencesProvider',
          desc = "List the symbol's usages",
        },
        { '<C-', {
          { 'a>',
            function()
              require('fzf-lua').lsp_code_actions()
            end,
            cond = client_supports 'codeActionProvider',
            desc = 'Code actions (fuzzy)',
          },
          { 'i>',
            function()
              require('fzf-lua').lsp_incoming_calls()
            end,
            cond = client_supports 'incomingCallsProvider',
            desc = 'Incoming calls (fuzzy)',
          },
          { 'o>',
            function()
              require('fzf-lua').lsp_outgoing_calls()
            end,
            cond = client_supports 'outgoindCallsProvider',
            desc = 'Outgoing calls (fuzzy)',
          },
          { 'r>',
            function()
              require('fzf-lua').lsp_references()
            end,
            cond = client_supports 'referencesProvider',
            desc = "Symbol's references (fuzzy)",
          },
          { 's>',
            function()
              require('fzf-lua').lsp_workspace_symbols()
            end,
            cond = client_supports 'workspaceSymbolProvider',
            desc = 'Workspace symbols (fuzzy)',
          },
        }},
      }},
    }
  end,
}
