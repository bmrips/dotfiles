return {
  default = {
    { "<BS>",
      "<Plug>(LoupeClearHighlight)",
      desc = "Clear search highlighting",
      remap = true,
    },
    { "<CR>",
      function()
        local type = vim.opt_local.buftype:get()
        if type == "quickfix" or type == "prompt" or type == "nofile" then
          return "<CR>"
        else
          return "<C-^>"
        end
      end,
      desc = "Switch to alternate buffer",
      expr = true,
    },
    { "<Space>",
      ":",
      desc = "Enter command line",
      mode = "",
    },
    { "<Tab>",
      function()
        require("fold-cycle").open()
      end,
      desc = "Open folds under cursor",
    },
    { "<S-Tab>",
      function()
        require("fold-cycle").close()
      end,
      desc = "Close folds under cursor",
    },
    { "[", {
      { "d",
        vim.diagnostic.goto_prev,
        desc = "Previous diagnostic",
      },
      { "D",
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        desc = "Previous error",
      },
    }},
    { "]", {
      { "d",
        vim.diagnostic.goto_prev,
        desc = "Next diagnostic",
      },
      { "D",
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        desc = "Next error",
      },
    }},
    { "g", {
      { "a",
        "<Plug>(EasyAlign)",
        desc = "Align",
        mode = "",
        noremap = false,
      },
      { "o",
        ":Sort i<CR>",
        desc = "Sort",
        mode = "x",
      },
      { "s",
        ":%s/\\v/g<Left><Left>",
        desc = "Substitute globally",
      },
      { "s",
        ":s/\\v/g<Left><Left>",
        desc = "Substitute in selection",
        mode = "x",
      },
      { "S",
        ":sil gr! <C-R><C-w><CR>",
        desc = "Grep word under cursor",
      },
      { "<C-", {
        { "a>",
          require("dial.map").inc_gvisual(),
          desc = "Increment stepwise",
          mode = "x",
        },
        { "x>",
          require("dial.map").dec_gvisual(),
          desc = "Decrement stepwise",
          mode = "x",
        },
      }},
    }},
    { "m", {
      { "<CR>",
        "<Cmd>make!<CR>",
        desc = "Make",
      },
      { "<Space>",
        ":<C-U>make!<Space>",
        desc = "Make given target",
      },
    }},
    { "S",
      ":%s/\\v\\C<<C-r><C-w>>//g<Left><Left>",
      desc = "Substitute word under cursor",
    },
    { "U",
      "<Cmd>MundoToggle<CR>",
      desc = "Open undo tree",
    },
    { "z", {
      { "A",
        function()
          require("fold-cycle").toggle_all()
        end,
        desc = "Toggle all folds under cursor",
        noremap = false,
      },
      { "C",
        function()
          require("fold-cycle").close_all()
        end,
        desc = "Close all folds under cursor",
        noremap = false,
      },
      { "F",
        "':Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'",
        desc = "Create fold of given level",
        expr = true,
        mode = "",
      },
      { "O",
        function()
          require("fold-cycle").open_all()
        end,
        desc = "Open all folds under cursor",
        noremap = false,
      },
    }},
    { "<A-", {
      { "c>",
        "<Cmd>tabclose<CR>",
        desc = "Close tab",
      },
      { "h>",
        "'<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'",
        desc = "Move tab left",
        expr = true,
      },
      { "j>",
        "<Cmd>tabnext<CR>",
        desc = "Next tab",
      },
      { "k>",
        "<Cmd>tabprev<CR>",
        desc = "Previous tab",
      },
      { "l>",
        "'<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'",
        desc = "Move tab right",
        expr = true,
      },
      { "n>",
        "<Cmd>tabnew<CR>",
        desc = "New tab",
      },
      { "o>",
        "<Cmd>tabonly<CR>",
        desc = "Close all other tabs",
      },
      { "Tab>",
        "g<Tab>",
        desc = "Go to alternate tab",
      },
    }},
    { "<C-", {
      { "Left>",
        "<C-w><",
        desc = "Decrease window width",
      },
      { "Down>",
        "<C-w>-",
        desc = "Decrease window height",
      },
      { "Up>",
        "<C-w>+",
        desc = "Increase window height",
      },
      { "Right>",
        "<C-w>>",
        desc = "Increase window width",
      },
      { "a>",
        require("dial.map").inc_normal(),
        desc = "Increment",
      },
      { "a>",
        require("dial.map").inc_visual(),
        desc = "Increment",
        mode = "x",
      },
      { "h>",
        "<Cmd>wincmd h<CR>",
        desc = "Go to left window",
      },
      { "j>",
        "<Cmd>wincmd j<CR>",
        desc = "Go to down window",
      },
      { "k>",
        "<Cmd>wincmd k<CR>",
        desc = "Go to up window",
      },
      { "l>",
        "<Cmd>wincmd l<CR>",
        desc = "Go to right window",
      },
      { "p>",
        "<C-i>",
        mode = "",
        desc = "Go forward in jump list",
      },
      { "w>", {
        { "<CR>",
          "<Cmd>wincmd ^<CR>",
          desc = "Open alternate buffer in split",
        },
        { "}>",
          "<Cmd>tab wincmd ]<CR>",
          desc = "Jump to tag in tab split",
        },
        { "D>",
          "<Cmd>tab wincmd d<CR>",
          desc = "Open definition in tab split",
        },
        { "F>",
          "<Cmd>tab wincmd f<CR>",
          desc = "Open file in tab split",
        },
        { "I>",
          "<Cmd>tab wincmd i<CR>",
          desc = "Open import in tab split",
        },
        { "m",
          "<Cmd>WinShift<CR>",
          desc = "Move interactively",
        },
        { "X",
          "<Cmd>WinShift swap<CR>",
          desc = "Swap interactively",
        },
        { "<C-", {
          { "]>",
            "<Cmd>vertical wincmd ]<CR>",
            desc = "Jump to tag in vert split",
          },
          { "d>",
            "<Cmd>vertical wincmd d<CR>",
            desc = "Open definition in vert split",
          },
          { "f>",
            "<Cmd>vertical wincmd f<CR>",
            desc = "Open file in vert split",
          },
          { "i>",
            "<Cmd>vertical wincmd i<CR>",
            desc = "Open import in vert split",
          },
        }},
      }},
      { "x>",
        require("dial.map").dec_normal(),
        desc = "Decrement",
      },
      { "x>",
        require("dial.map").dec_visual(),
        desc = "Decrement",
        mode = "x",
      },
      { (vim.g.neovide and "/" or "_") .. ">", {
        { "<C-"..(vim.g.neovide and "/" or "_")..">",
          function()
            require("fzf-lua").resume()
          end,
          desc = "Resume"
        },
        { ":",
          function()
            require("fzf-lua").command_history()
          end,
          desc = "Command history",
        },
        { "/",
          function()
            require("fzf-lua").search_history()
          end,
          desc = "Search history",
        },
        { "?",
          function()
            require("fzf-lua").search_history()
          end,
          desc = "Search history",
        },
        { "a",
          function()
            require("fzf-lua").args()
          end,
          desc = "Arguments",
        },
        { "b",
          function()
            require("fzf-lua").buffers()
          end,
          desc = "Buffers",
        },
        { "c",
          function()
            require("fzf-lua").commands()
          end,
          desc = "Commands",
        },
        { "C",
          function()
            require("fzf-lua").colorschemes()
          end,
          desc = "Colorschemes",
        },
        { "f",
          function()
            require("fzf-lua").files()
          end,
          desc = "Files",
        },
        { "F",
          function()
            require("fzf-lua").oldfiles()
          end,
          desc = "Recent Files",
        },
        { "<C-f>",
          function()
            require("fzf-lua").git_files()
          end,
          desc = "Git-tracked files",
        },
        { "g",
          function()
            require("fzf-lua").live_grep()
          end,
          desc = "Grep",
        },
        { "G",
          function()
            require("fzf-lua").live_grep_resume()
          end,
          desc = "Resume last grep",
        },
        { "<C-g>",
          function()
            require("fzf-lua").live_grep_glob()
          end,
          desc = "Grep with --glob",
        },
        { "h",
          function()
            require("fzf-lua").help_tags()
          end,
          desc = "Help tags",
        },
        { "H",
          function()
            require("fzf-lua").man_pages()
          end,
          desc = "Man pages",
        },
        { "j",
          function()
            require("fzf-lua").jumps()
          end,
          desc = "Jumps",
        },
        { "k",
          function()
            require("fzf-lua").keymaps()
          end,
          desc = "Keymaps",
        },
        { "l",
          function()
            require("fzf-lua").lines()
          end,
          desc = "Buffer lines",
        },
        { "L",
          function()
            require("fzf-lua").blines()
          end,
          desc = "Current buffer lines",
        },
        { "m",
          function()
            require("fzf-lua").marks()
          end,
          desc = "Marks",
        },
        { "o",
          function()
            require("fzf-lua").grep_cword()
          end,
          desc = "Grep word under cursor",
        },
        { "O",
          function()
            require("fzf-lua").grep_cWORD()
          end,
          desc = "Grep WORD under cursor",
        },
        { "<C-o>",
          function()
            require("fzf-lua").grep_visual()
          end,
          desc = "Grep visual selection",
        },
        { "p",
          function()
            require("fzf-lua").packadd()
          end,
          desc = "Add package",
        },
        { "q",
          function()
            require("fzf-lua").quickfix()
          end,
          desc = "Quickfix list",
        },
        { "Q",
          function()
            require("fzf-lua").loclist()
          end,
          desc = "Location list",
        },
        { "r",
          function()
            require("fzf-lua").registers()
          end,
          desc = "Registers",
        },
        { "s",
          function()
            require("fzf-lua").spell_suggest()
          end,
          desc = "Spelling suggestions",
        },
        { "t",
          function()
            require("fzf-lua").filetypes()
          end,
          desc = "Filetypes",
        },
        { "T",
          function()
            require("fzf-lua").tagstack()
          end,
          desc = "Tags",
        },
      }},
    }},
    { "<Leader>", {
      { "i",
        "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>",
        desc = "Include file under cursor",
      },
      { "n",
        function() require("notify").dismiss() end,
        desc = "Dismiss notifications",
      },
      { "s",
        "<Cmd>ToggleSession<CR>",
        desc = "Toggle session recording",
      },
      { "t",
        "<Cmd>Drex<CR>",
        desc = "Open explorer",
      },
      { "T",
        ":Drex",
        desc = "Open explorer in given dir",
      },
      { "<C-t>",
        "<Cmd>DrexDrawerOpen<CR>",
        desc = "Open file drawer",
      },
    }},
    { "<LocalLeader>", {
      { "d",
        "<Cmd>TroubleToggle<CR>",
        desc = "Toggle diagnostics list",
      },
      { "D",
        function()
          local config = vim.diagnostic.config() or
                        { virtual_text = true, virtual_lines = false }
          vim.diagnostic.config {
            virtual_text = not config.virtual_text,
            virtual_lines = not config.virtual_lines,
          }
        end,
        desc = "Toggle inline/virtual diagnostics",
      },
      { "<C-d>",
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
        desc = "Fzf: diagnostics",
      },
    }},

    { mode = "i", {
      { "jk",
        "<Esc>",
        desc = "Escape insert mode",
      },
    }},

    { mode = "c", "<C-", {
      { "j>",
        "<Down>",
        desc = "Recall newer cmdline with matching beginning",
      },
      { "k>",
        "<Up>",
        desc = "Recall older cmdline with matching beginning",
      },
      { "n>",
        'getcmdtype() =~ "[/?]" ? "<CR>/<C-r>/" : "<C-n>"',
        desc = "Find next pattern match",
        expr = true,
      },
      { "p>",
        'getcmdtype() =~ "[/?]" ? "<CR>?<C-r>/" : "<C-p>"',
        desc = "Find previous pattern match",
        expr = true,
      },
    }},
  },
  lsp = function(capabilities) -- Adapt the keymaps to the client's capabilities
    return {
      { "K",
        vim.lsp.buf.hover,
        cond = capabilities.hoverProvider ~= nil,
        desc = "Hover symbol under cursor",
      },
      { "S",
        vim.lsp.buf.rename,
        cond = capabilities.renameProvider ~= nil,
        desc = "Rename symbol under cursor",
      },
      { "g", {
        { "d",
          function()
            require("util.lsp.goto").location("definition")
          end,
          cond = capabilities.definitionProvider ~= nil,
          desc = "Go to/list definition(s)",
        },
        { "D",
          function()
            require("util.lsp.goto").location("declaration")
          end,
          cond = capabilities.declarationProvider ~= nil,
          desc = "Go to/list declaration(s)",
        },
        { "i",
          function()
            require("util.lsp.goto").location("implementation")
          end,
          cond = capabilities.implementationProvider ~= nil,
          desc = "Go to/list implementation(s)",
        },
        { "t",
          function()
            require("util.lsp.goto").location("type_definition")
          end,
          cond = capabilities.typeDefinitionProvider ~= nil,
          desc = "Go to/list type definition(s)",
        },
      }},
      { "<C-w>", {
        { "d",
          function()
            require("util.lsp.goto").location("definition", "split")
          end,
          cond = capabilities.definitionProvider ~= nil,
          desc = "Open definition(s) in split",
        },
        { "D",
          function()
            require("util.lsp.goto").location("definition", "tab split")
          end,
          cond = capabilities.definitionProvider ~= nil,
          desc = "Open definition(s) in tab split",
        },
        { "<C-d>",
          function()
            require("util.lsp.goto").location("definition", "vert split")
          end,
          cond = capabilities.definitionProvider ~= nil,
          desc = "Open definition(s) in vert split",
        },
        { "i",
          function()
            require("util.lsp.goto").location("implementation", "split")
          end,
          cond = capabilities.implementationProvider ~= nil,
          desc = "Open implementation(s) in split",
        },
        { "I",
          function()
            require("util.lsp.goto").location("implementation", "tab split")
          end,
          cond = capabilities.implementationProvider ~= nil,
          desc = "Open implementation(s) in tab split",
        },
        { "<C-i>",
          function()
            require("util.lsp.goto").location("implementation", "vert split")
          end,
          cond = capabilities.implementationProvider ~= nil,
          desc = "Open implementation(s) in vert split",
        },
        { "t",
          function()
            require("util.lsp.goto").location("type_definition", "split")
          end,
          cond = capabilities.typeDefinitionProvider ~= nil,
          desc = "Open type definition(s) in split",
        },
        { "T",
          function()
            require("util.lsp.goto").location("type_definition", "tab split")
          end,
          cond = capabilities.typeDefinitionProvider ~= nil,
          desc = "Open type definition(s) in tab split",
        },
        { "<C-t>",
          function()
            require("util.lsp.goto").location("type_definition", "vert split")
          end,
          cond = capabilities.typeDefinitionProvider ~= nil,
          desc = "Open type definition(s) in vert split",
        },
      }},
      { "<LocalLeader>", {
        { "a",
          vim.lsp.buf.code_action,
          cond = capabilities.codeActionProvider ~= nil,
          desc = "Invoke a code action",
        },
        { "f",
          function()
            vim.lsp.buf.format {async = false}
          end,
          cond = capabilities.documentFormatProvider ~= nil,
          desc = "Format the buffer",
        },
        { "i",
          vim.lsp.buf.incoming_calls,
          cond = capabilities.incomingCallsProvider ~= nil,
          desc = "List incoming calls",
        },
        { "k",
          vim.lsp.buf.signature_help,
          cond = capabilities.signatureHelpProvider ~= nil,
          desc = "Show the symbol's signature",
        },
        { "o",
          vim.lsp.buf.outgoing_calls,
          cond = capabilities.outgoingCallsProvider ~= nil,
          desc = "List outgoing calls",
        },
        { "r",
          vim.lsp.buf.references,
          cond = capabilities.referencesProvider ~= nil,
          desc = "List the symbol's references",
        },
        { "s",
          vim.lsp.buf.workspace_symbol,
          cond = capabilities.workspaceSymbolProvider ~= nil,
          desc = "List all workspace symbols",
        },
        { "S",
          vim.lsp.buf.document_symbol,
          cond = capabilities.documentSymbolProvider ~= nil,
          desc = "List all document symbols",
        },
        { "w", {
          { "a",
            vim.lsp.buf.add_workspace_folder,
            desc = "Add workspace folder",
          },
          { "l",
            function()
              vim.pretty_print(vim.lsp.buf.list_workspace_folders())
            end,
            desc = "List workspace folders",
          },
          { "r",
            vim.lsp.buf.remove_workspace_folder,
            desc = "Remove workspace folder",
          },
        }},
        { "<C-", {
          { "i>",
            function()
              require("fzf-lua").lsp_incoming_calls()
            end,
            cond = capabilities.incomingCallsProvider ~= nil,
            desc = "Fzf: incoming calls",
          },
          { "o>",
            function()
              require("fzf-lua").lsp_outgoing_calls()
            end,
            cond = capabilities.outgoindCallsProvider ~= nil,
            desc = "Fzf: outgoing calls",
          },
          { "r>",
            function()
              require("fzf-lua").lsp_references()
            end,
            cond = capabilities.referencesProvider ~= nil,
            desc = "Fzf: symbol's references",
          },
          { "s>",
            function()
              require("fzf-lua").lsp_workspace_symbols()
            end,
            cond = capabilities.workspaceSymbolProvider ~= nil,
            desc = "Fzf: workspace symbols",
          },
        }},
      }},
    }
  end,
}
