return {
  default = {
    { "<BS>", "<Plug>(LoupeClearHighlight)", options = {
      noremap = false,
        desc = "Clear search highlighting",
    }},
    { "<CR>",
      options = {
        expr = true,
        desc = "Switch to alternate buffer",
      },
      function()
        local type = vim.opt_local.buftype:get()
        if type == "quickfix" or type == "prompt" or type == "nofile" then
          return "<CR>"
        else
          return "<C-^>"
        end
      end,
    },
    { "<Space>", ":", mode = "_", options = {
      desc = "Enter command line",
    }},
    { "<Tab>", function() require("fold-cycle").open() end, options = {
      desc = "Open folds under cursor",
    }},
    { "<S-Tab>", function() require("fold-cycle").close() end, options = {
      desc = "Close folds under cursor",
    }},
    { "'", "`" },
    { "[", {
      { "d", vim.diagnostic.goto_prev, options = {
        desc = "Previous diagnostic",
      }},
      { "D",
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        options = {
          desc = "Previous error",
        },
      },
    }},
    { "]", {
      { "d", vim.diagnostic.goto_prev, options = {
        desc = "Next diagnostic",
      }},
      { "D",
        function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end,
        options = {
          desc = "Next error",
        },
      },
    }},
    { "g", {
      { "a", "<Plug>(EasyAlign)", mode = "_", options = {
        noremap = false,
        desc = "Align",
      }},
      { "o", ":Sort<CR>", mode = "x", options = {
        desc = "Sort",
      }},
      { "s", ":%s/\\v/g<Left><Left>", options = {
        desc = "Substitute globally",
      }},
      { "s", ":s/\\v/g<Left><Left>", mode = "x", options = {
        desc = "Substitute in selection",
      }},
      { "S", ":sil gr! <C-R><C-w><CR>", options = {
        desc = "Grep word under cursor",
      }},
      { "<C-", {
        { "a>", require("dial.map").inc_gvisual(), mode = "x", options = {
          desc = "Increment stepwise",
        }},
        { "x>", require("dial.map").dec_gvisual(), mode = "x", options = {
          desc = "Decrement stepwise",
        }},
      }},
    }},
    { "m", {
      { "<CR>", "<Cmd>make!<CR>", options = {
        desc = "Make",
      }},
      { "<Space>", ":<C-U>make!<Space>", options = {
        desc = "Make given target",
      }},
    }},
    { "S", ":%s/\\v\\C<<C-r><C-w>>//g<Left><Left>", options = {
      desc = "Substitute word under cursor",
    }},
    { "U", "<Cmd>MundoToggle<CR>", options = {
      desc = "Open undo tree",
    }},
    { "z", {
      { "A", function() require("fold-cycle").toggle_all() end, options = {
        noremap = false,
        desc = "Toggle all folds under cursor",
      }},
      { "C", function() require("fold-cycle").close_all() end, options = {
        noremap = false,
        desc = "Close all folds under cursor",
      }},
      { "F", "':Fold '.v:count.' | silent! call repeat#set(\"zF\", '.v:count.')<CR>'", mode = "_", options = {
        expr = true,
        desc = "Create fold of given level",
      }},
      { "O", function() require("fold-cycle").open_all() end, options = {
        noremap = false,
        desc = "Open all folds under cursor",
      }},
    }},
    { "<A-", {
      { "c>", "<Cmd>tabclose<CR>", options = {
        desc = "Close tab",
      }},
      { "h>", "'<Cmd>silent! tabmove '.(tabpagenr()-2).'<CR>'", options = {
        expr = true,
        desc = "Move tab left",
      }},
      { "j>", "<Cmd>tabnext<CR>", options = {
        desc = "Next tab",
      }},
      { "k>", "<Cmd>tabprev<CR>", options = {
        desc = "Previous tab",
      }},
      { "l>", "'<Cmd>silent! tabmove '.(tabpagenr()+1).'<CR>'", options = {
        expr = true,
        desc = "Move tab right"
      }},
      { "n>", "<Cmd>tabnew<CR>", options = {
        desc = "New tab",
      }},
      { "o>", "<Cmd>tabonly<CR>", options = {
        desc = "Close all other tabs",
      }},
      { "Tab>", "g<Tab>", options = {
        desc = "Go to alternate tab",
      }},
    }},
    { "<C-", {
      { "Left>", "<C-w><", options = {
        desc = "Decrease window width",
      }},
      { "Down>", "<C-w>-", options = {
        desc = "Decrease window height",
      }},
      { "Up>", "<C-w>+", options = {
        desc = "Increase window height",
      }},
      { "Right>", "<C-w>>", options = {
        desc = "Increase window width",
      }},
      { "a>", require("dial.map").inc_normal(), options = {
        desc = "Increment",
      }},
      { "a>", require("dial.map").inc_visual(), mode = "x", options = {
        desc = "Increment",
      }},
      { "h>", "<Cmd>wincmd h<CR>", options = {
        desc = "Go to left window",
      }},
      { "j>", "<Cmd>wincmd j<CR>", options = {
        desc = "Go to down window",
      }},
      { "k>", "<Cmd>wincmd k<CR>", options = {
        desc = "Go to up window",
      }},
      { "l>", "<Cmd>wincmd l<CR>", options = {
        desc = "Go to right window",
      }},
      { "p>", "<C-i>", mode = "_", options = {
        desc = "Go forward in jump list",
      }},
      { "w>", {
        { "<CR>", "<Cmd>wincmd ^<CR>", options = {
          desc = "Open alternate buffer in split",
        }},
        { "}>", "<Cmd>tab wincmd ]<CR>", options = {
          desc = "Jump to tag in tab split",
        }},
        { "D>", "<Cmd>tab wincmd d<CR>", options = {
          desc = "Open definition in tab split",
        }},
        { "F>", "<Cmd>tab wincmd f<CR>", options = {
          desc = "Open file in tab split",
        }},
        { "I>", "<Cmd>tab wincmd i<CR>", options = {
          desc = "Open import in tab split",
        }},
        { "m", "<Cmd>WinShift<CR>", options = {
          desc = "Move interactively",
        }},
        { "X", "<Cmd>WinShift swap<CR>", options = {
          desc = "Swap interactively",
        }},
        { "<C-", {
          { "]>", "<Cmd>vertical wincmd ]<CR>", options = {
            desc = "Jump to tag in vert split",
          }},
          { "d>", "<Cmd>vertical wincmd d<CR>", options = {
            desc = "Open definition in vert split",
          }},
          { "f>", "<Cmd>vertical wincmd f<CR>", options = {
            desc = "Open file in vert split",
          }},
          { "i>", "<Cmd>vertical wincmd i<CR>", options = {
            desc = "Open import in vert split",
          }},
        }},
      }},
      { "x>", require("dial.map").dec_normal(), options = {
        desc = "Decrement",
      }},
      { "x>", require("dial.map").dec_visual(), mode = "x", options = {
        desc = "Decrement",
      }},
      { (vim.g.neovide and "/" or "_") .. ">", {
        { "<C-"..(vim.g.neovide and "/" or "_")..">", "<Cmd>FzfLua resume<CR>", options = {
          desc = "Resume"
        }},
        { ":", "<Cmd>FzfLua command_history<CR>", options = {
          desc = "Command history",
        }},
        { "/", "<Cmd>FzfLua search_history<CR>", options = {
          desc = "Search history",
        }},
        { "?", "<Cmd>FzfLua search_history<CR>", options = {
          desc = "Search history",
        }},
        { "a", "<Cmd>FzfLua args<CR>", options = {
          desc = "Arguments",
        }},
        { "b", "<Cmd>FzfLua buffers<CR>", options = {
          desc = "Buffers",
        }},
        { "c", "<Cmd>FzfLua commands<CR>", options = {
          desc = "Commands",
        }},
        { "C", "<Cmd>FzfLua colorschemes<CR>", options = {
          desc = "Colorschemes",
        }},
        { "f", "<Cmd>FzfLua files<CR>", options = {
          desc = "Files",
        }},
        { "F", "<Cmd>FzfLua oldfiles<CR>", options = {
          desc = "Recent Files",
        }},
        { "<C-f>", "<Cmd>FzfLua git_files<CR>", options = {
          desc = "Git-tracked files",
        }},
        { "g", "<Cmd>FzfLua live_grep<CR>", options = {
          desc = "Grep",
        }},
        { "G", "<Cmd>FzfLua live_grep_resume<CR>", options = {
          desc = "Resume last grep",
        }},
        { "<C-g>", "<Cmd>FzfLua live_grep_glob<CR>", options = {
          desc = "Grep with --glob",
        }},
        { "h", "<Cmd>FzfLua help_tags<CR>", options = {
          desc = "Help tags",
        }},
        { "H", "<Cmd>FzfLua man_pages<CR>", options = {
          desc = "Man pages",
        }},
        { "j", "<Cmd>FzfLua jumps<CR>", options = {
          desc = "Jumps",
        }},
        { "k", "<Cmd>FzfLua keymaps<CR>", options = {
          desc = "Keymaps",
        }},
        { "l", "<Cmd>FzfLua lines<CR>", options = {
          desc = "Buffer lines",
        }},
        { "L", "<Cmd>FzfLua blines<CR>", options = {
          desc = "Current buffer lines",
        }},
        { "m", "<Cmd>FzfLua marks<CR>", options = {
          desc = "Marks",
        }},
        { "o", "<Cmd>FzfLua grep_cword<CR>", options = {
          desc = "Grep word under cursor",
        }},
        { "O", "<Cmd>FzfLua grep_cWORD<CR>", options = {
          desc = "Grep WORD under cursor",
        }},
        { "<C-o>", "<Cmd>FzfLua grep_visual<CR>", options = {
          desc = "Grep visual selection",
        }},
        { "p", "<Cmd>FzfLua packadd<CR>", options = {
          desc = "Add package",
        }},
        { "q", "<Cmd>FzfLua quickfix<CR>", options = {
          desc = "Quickfix list",
        }},
        { "Q", "<Cmd>FzfLua loclist<CR>", options = {
          desc = "Location list",
        }},
        { "r", "<Cmd>FzfLua registers<CR>", options = {
          desc = "Registers",
        }},
        { "s", "<Cmd>FzfLua spell_suggest<CR>", options = {
          desc = "Spelling suggestions",
        }},
        { "t", "<Cmd>FzfLua filetypes<CR>", options = {
          desc = "Filetypes",
        }},
        { "T", "<Cmd>FzfLua tagstack<CR>", options = {
          desc = "Tags",
        }},
      }},
    }},
    { "<Leader>", {
      { "i", "<Cmd>call append('.', readfile(findfile(expand('<cfile>')))) | delete<CR>", options = {
        desc = "Include file under cursor",
      }},
      { "n", function() require("notify").dismiss() end, options = {
        desc = "Dismiss notifications",
      }},
      { "s", "<Cmd>ToggleSession<CR>", options = {
        desc = "Toggle session recording",
      }},
      { "t", "<Cmd>Drex<CR>", options = {
        desc = "Open explorer",
      }},
      { "T", ":Drex", options = {
        desc = "Open explorer in given dir",
      }},
      { "<C-t>", "<Cmd>DrexDrawerOpen<CR>", options = {
        desc = "Open file drawer",
      }},
    }},
    { "<LocalLeader>", {
      { "d", "<Cmd>TroubleToggle<CR>", options = {
        desc = "Toggle diagnostics list",
      }},
      { "D",
        function()
          local config = vim.diagnostic.config() or
                        { virtual_text = true, virtual_lines = false }
          vim.diagnostic.config {
            virtual_text = not config.virtual_text,
            virtual_lines = not config.virtual_lines,
          }
        end,
        options = {
          desc = "Toggle inline/virtual diagnostics"
        },
      },
      { "<C-d>", "<Cmd>FzfLua diagnostics_workspace<CR>", options = {
        desc = "Fzf: diagnostics",
      }},
    }},

    { mode = "i", {
      { "jk", "<Esc>", options = {
        desc = "Escape insert mode",
      }},
    }},

    { mode = "c", "<C-", {
      { "j>", "<Down>", options = {
        desc = "Recall newer cmdline with matching beginning",
      }},
      { "k>", "<Up>", options = {
        desc = "Recall older cmdline with matching beginning",
      }},
      { "n>", 'getcmdtype() =~ "[/?]" ? "<CR>/<C-r>/" : "<C-n>"', options = {
        expr = true,
        desc = "Find next pattern match",
      }},
      { "p>", 'getcmdtype() =~ "[/?]" ? "<CR>?<C-r>/" : "<C-p>"', options = {
        expr = true,
        desc = "Find previous pattern match",
      }},
    }},
  },
  lsp = { buffer = true, {
    { "K", vim.lsp.buf.hover, options = {
      desc = "Hover symbol under cursor",
    }},
    { "S", vim.lsp.buf.rename, options = {
      desc = "Rename symbol under cursor",
    }},
    { "g", {
      { "d", vim.lsp.buf.definition, options = {
        desc = "Go to/list definition(s)",
      }},
      { "D", vim.lsp.buf.declaration, options = {
        desc = "Go to/list declaration(s)",
      }},
      { "i", vim.lsp.buf.implementation, options = {
        desc = "Go to/list implementation(s)",
      }},
      { "t", vim.lsp.buf.type_definition, options = {
        desc = "Go to/list type definition(s)",
      }},
    }},
    { "<LocalLeader>", {
      { "a", vim.lsp.buf.code_action, options = {
        desc = "Invoke a code action",
      }},
      { "f",
        function()
          vim.lsp.buf.format {async = false}
        end,
        options = {
          desc = "Format the buffer",
        },
      },
      { "i", vim.lsp.buf.incoming_calls, options = {
        desc = "List incoming calls",
      }},
      { "k", vim.lsp.buf.signature_help, options = {
        desc = "Show the symbol's signature",
      }},
      { "o", vim.lsp.buf.outgoing_calls, options = {
        desc = "List outgoing calls",
      }},
      { "r", vim.lsp.buf.references, options = {
        desc = "List the symbol's references",
      }},
      { "s", vim.lsp.buf.workspace_symbol, options = {
        desc = "List all workspace symbols",
      }},
      { "S", vim.lsp.buf.document_symbol, options = {
        desc = "List all document symbols",
      }},
      { "w", {
        { "a", vim.lsp.buf.add_workspace_folder, options = {
          desc = "Add workspace folder",
        }},
        { "l",
          function()
            vim.pretty_print(vim.lsp.buf.list_workspace_folders())
          end,
          options = {
            desc = "List workspace folders"
          },
        },
        { "r", vim.lsp.buf.remove_workspace_folder, options = {
          desc = "Remove workspace folder",
        }},
      }},
      { "<C-", {
        { "i>", "<Cmd>FzfLua lsp_incoming_calls<CR>", options = {
          desc = "Fzf: incoming calls",
        }},
        { "o>", "<Cmd>FzfLua lsp_outgoing_calls<CR>", options = {
          desc = "Fzf: outgoing calls",
        }},
        { "r>", "<Cmd>FzfLua lsp_references<CR>", options = {
          desc = "Fzf: symbol's references",
        }},
        { "s>", "<Cmd>FzfLua lsp_workspace_symbol<CR>", options = {
          desc = "Fzf: workspace symbols",
        }},
      }},
    }},
  }},
}
