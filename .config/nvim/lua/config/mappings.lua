local ctrl_slash = (vim.g.neovide or vim.env.ITERM_PROFILE)
  and '/'
  or  '_'

return {
  init = {
    { '<BS>',
      '<Cmd>nohlsearch | call loupe#private#clear_highlight() | diffupdate | normal! <C-l><CR>',
      desc = 'Clear search highlighting',
      remap = true,
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
    { '<Space>',
      ':',
      desc = 'Enter command line',
      mode = '',
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
      mode = '',
      remap = true,
    },
    { '<Up>',
      'k',
      mode = '',
      remap = true,
    },
    { '[', {
      { 'd',
        vim.diagnostic.goto_prev,
        desc = 'Previous diagnostic',
      },
      { 'D',
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        desc = 'Previous error',
      },
    }},
    { ']', {
      { 'd',
        vim.diagnostic.goto_next,
        desc = 'Next diagnostic',
      },
      { 'D',
        function()
          vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
        end,
        desc = 'Next error',
      },
    }},
    { 'g', {
      { 'a',
        '<Plug>(EasyAlign)',
        desc = 'Align',
        mode = '',
        remap = true,
      },
      { 'l',
        function()
          return require('pantran').motion_translate()
        end,
        desc = 'Translate',
        expr = true,
        mode = '',
      },
      { 'L',
        function()
          return require('pantran').motion_translate() .. '_'
        end,
        desc = 'Translate',
        expr = true,
      },
      { 'm',
        [[:%s/\v\C<<C-r><C-w>>//g<Left><Left>]],
        desc = 'Move word under cursor',
      },
      { 'M',
        [[:%s/\v/g<Left><Left>]],
        desc = 'Move pattern',
      },
      { 'M',
        [[:s/\v/g<Left><Left>]],
        desc = 'Move pattern',
        mode = 'x',
      },
      { 'o',
        function()
          _G._operatorfunc = function()
            local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, '['))
            local stop_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ']'))
            vim.cmd.sort {
              args = { 'i' },
              range = { start_row, stop_row },
            }
          end

          vim.opt.operatorfunc = 'v:lua._operatorfunc'
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
      { 's',
        function ()
          require('leap').leap {
            target_windows = require('leap.util').get_enterable_windows(),
          }
        end,
        desc = 'Leap outside',
        mode = { 'n', 'x', 'o' },
      },
      { '/',
        ':sil gr! <C-R><C-w><CR>',
        desc = 'Grep word under cursor',
      },
      { '<C-', {
        { 'a>',
          require('dial.map').inc_gnormal(),
          desc = 'Increment stepwise',
        },
        { 'a>',
          require('dial.map').inc_gvisual(),
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
          require('dial.map').dec_gnormal(),
          desc = 'Decrement stepwise',
        },
        { 'x>',
          require('dial.map').dec_gvisual(),
          desc = 'Decrement stepwise',
          mode = 'x',
        },
      }},
    }},
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
        require('leap').leap {}
      end,
      desc = 'Leap forward',
      mode = { 'n', 'x', 'o' },
    },
    { 'S',
      function()
        require('leap').leap { backward = true }
      end,
      desc = 'Leap backward',
      mode = { 'n', 'x', 'o' },
    },
    { 'U',
      '<Cmd>MundoToggle<CR>',
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
        mode = '',
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
        require('dial.map').inc_normal(),
        desc = 'Increment',
      },
      { 'a>',
        require('dial.map').inc_visual(),
        desc = 'Increment',
        mode = 'x',
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
        mode = '',
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
        { '}>',
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
        { 'D>',
          '<Cmd>tab wincmd d<CR>',
          desc = 'Open definition in tab split',
        },
        { 'F>',
          '<Cmd>tab wincmd f<CR>',
          desc = 'Open file in tab split',
        },
        { 'I>',
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
          { 'r>',
            function()
              require('smart-splits').start_resize_mode()
            end,
            desc = 'Enter resize mode'
          },
        }},
      }},
      { 'x>',
        require('dial.map').dec_normal(),
        desc = 'Decrement',
      },
      { 'x>',
        require('dial.map').dec_visual(),
        desc = 'Decrement',
        mode = 'x',
      },
      { ctrl_slash .. '>', {
        { '<C-'..ctrl_slash..'>',
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
            require('fzf-lua').oldfiles()
          end,
          desc = 'Recent Files',
        },
        { '<C-f>',
          function()
            require('fzf-lua').git_files()
          end,
          desc = 'Git-tracked files',
        },
        { 'g',
          function()
            require('fzf-lua').live_grep()
          end,
          desc = 'Grep',
        },
        { 'G',
          function()
            require('fzf-lua').live_grep_resume()
          end,
          desc = 'Resume last grep',
        },
        { '<C-g>',
          function()
            require('fzf-lua').live_grep_glob()
          end,
          desc = 'Grep with --glob',
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
        { 'p',
          function()
            require('fzf-lua').packadd()
          end,
          desc = 'Add package',
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
    }},
    { '<Leader>', {
      { 'i',
        '<Cmd>call append(".", readfile(findfile(expand("<cfile>")))) | delete<CR>',
        desc = 'Include file under cursor',
      },
      { 'n',
        function() require('notify').dismiss() end,
        desc = 'Dismiss notifications',
      },
      { 's',
        '<Cmd>ToggleSession<CR>',
        desc = 'Toggle session recording',
      },
      { 't',
        '<Cmd>Drex<CR>',
        desc = 'Open explorer',
      },
      { 'T',
        ':Drex ',
        desc = 'Open explorer in given dir',
      },
      { '<C-t>',
        '<Cmd>DrexDrawerOpen<CR>',
        desc = 'Open file drawer',
      },
      { 'p', {
        { 'c',
          function()
            require('lazy').clean()
          end,
          desc = 'Compile',
        },
        { 'i',
          function()
            require('lazy').home()
          end,
          desc = 'Status',
        },
        { 's',
          function()
            require('lazy').sync()
          end,
          desc = 'Synchronise',
        },
      }},
    }},
    { '<LocalLeader>', {
      { 'd',
        '<Cmd>TroubleToggle<CR>',
        desc = 'Toggle diagnostics list',
      },
      { 'D',
        function()
          local config =
            vim.diagnostic.config() or
            { virtual_text = true, virtual_lines = false }
          vim.diagnostic.config {
            virtual_text = not config.virtual_text,
            virtual_lines = not config.virtual_lines,
          }
        end,
        desc = 'Toggle inline/virtual diagnostics',
      },
      { 'e',
        vim.diagnostic.open_float,
        desc = 'Show diagnostics under cursor',
      },
      { '<C-d>',
        function()
          require('fzf-lua').diagnostics_workspace()
        end,
        desc = 'Fzf: diagnostics',
      },
    }},

    { mode = 'i', {
      { '<Tab>',
        function()
          local luasnip = require 'luasnip'
          if luasnip.expand_or_jumpable() then
            luasnip.jump(1)
          else
            require('tabout').tabout()
          end
        end,
        desc = 'Jump to next snippet node',
      },
      { '<S-Tab>',
        function()
          local luasnip = require 'luasnip'
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            require('tabout').taboutBack()
          end
        end,
        desc = 'Jump to previous snippet node',
      },
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

    { mode = 's',
      { '<Tab>',
        function()
          require('luasnip').jump(1)
        end,
        desc = 'Jump to next snippet node',
      },
      { '<S-Tab>',
        function()
          require('luasnip').jump(-1)
        end,
        desc = 'Jump to previous snippet node',
      },
    },

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
            require('util.lsp.goto').location('definition')
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Go to/list definition(s)',
        },
        { 'D',
          function()
            require('util.lsp.goto').location('declaration')
          end,
          cond = client_supports 'declarationProvider',
          desc = 'Go to/list declaration(s)',
        },
        { 'i',
          function()
            require('util.lsp.goto').location('implementation')
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Go to/list implementation(s)',
        },
        { 't',
          function()
            require('util.lsp.goto').location('type_definition')
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Go to/list type definition(s)',
        },
      }},
      { '<C-w>', {
        { 'd',
          function()
            require('util.lsp.goto').location('definition', 'split')
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Open definition(s) in split',
        },
        { 'D',
          function()
            require('util.lsp.goto').location('definition', 'tab split')
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Open definition(s) in tab split',
        },
        { '<C-d>',
          function()
            require('util.lsp.goto').location('definition', 'vert split')
          end,
          cond = client_supports 'definitionProvider',
          desc = 'Open definition(s) in vert split',
        },
        { 'i',
          function()
            require('util.lsp.goto').location('implementation', 'split')
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Open implementation(s) in split',
        },
        { 'I',
          function()
            require('util.lsp.goto').location('implementation', 'tab split')
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Open implementation(s) in tab split',
        },
        { '<C-i>',
          function()
            require('util.lsp.goto').location('implementation', 'vert split')
          end,
          cond = client_supports 'implementationProvider',
          desc = 'Open implementation(s) in vert split',
        },
        { 't',
          function()
            require('util.lsp.goto').location('type_definition', 'split')
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Open type definition(s) in split',
        },
        { 'T',
          function()
            require('util.lsp.goto').location('type_definition', 'tab split')
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Open type definition(s) in tab split',
        },
        { '<C-t>',
          function()
            require('util.lsp.goto').location('type_definition', 'vert split')
          end,
          cond = client_supports 'typeDefinitionProvider',
          desc = 'Open type definition(s) in vert split',
        },
      }},
      { '<LocalLeader>', {
        { '/',
          function()
            require('fzf-lua').lsp_finder()
          end,
          desc = 'Fzf: all locations',
        },
        { 'a',
          vim.lsp.buf.code_action,
          cond = client_supports 'codeActionProvider',
          desc = 'Invoke a code action',
          mode = '',
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
        { 'f',
          vim.lsp.buf.format,
          cond = client_supports 'documentFormatProvider',
          desc = 'Format the buffer',
          mode = '',
        },
        { 'k',
          vim.lsp.buf.signature_help,
          cond = client_supports 'signatureHelpProvider',
          desc = "Show the symbol's signature",
        },
        { 'o',
          function()
            require('aerial').toggle()
          end,
          desc = 'Toggle outline',
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
            desc = 'Fzf: code actions',
          },
          { 'i>',
            function()
              require('fzf-lua').lsp_incoming_calls()
            end,
            cond = client_supports 'incomingCallsProvider',
            desc = 'Fzf: incoming calls',
          },
          { 'o>',
            function()
              require('fzf-lua').lsp_outgoing_calls()
            end,
            cond = client_supports 'outgoindCallsProvider',
            desc = 'Fzf: outgoing calls',
          },
          { 'r>',
            function()
              require('fzf-lua').lsp_references()
            end,
            cond = client_supports 'referencesProvider',
            desc = "Fzf: symbol's references",
          },
          { 's>',
            function()
              require('fzf-lua').lsp_workspace_symbols()
            end,
            cond = client_supports 'workspaceSymbolProvider',
            desc = 'Fzf: workspace symbols',
          },
        }},
      }},
    }
  end,
}
