return {
  { 'andymass/vim-matchup',
    config = function()
      -- Do not display off-screen matches
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }

      -- Defer highlighting to improve performance
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
  { 'ellisonleao/gruvbox.nvim' },
  { 'ethanholz/nvim-lastplace',
    config = true,
  },
  { 'f1rstlady/display-motions.nvim' },
  { 'f1rstlady/nest.nvim' },
  { 'f1rstlady/session.nvim' },
  { 'f1rstlady/vim-loupe',
    config = function()
      -- Do not center search results on n/N.
      vim.g.LoupeCenterResults = 0
    end,
  },
  { 'f1rstlady/vim-unimpaired' },
  { 'folke/lazy.nvim' },
  { 'folke/trouble.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = true,
  },
  { 'folke/which-key.nvim',
    config = {
      operators = {
        ga = 'Align'
      },
    },
  },
  { 'gpanders/editorconfig.nvim' },
  { 'hrsh7th/nvim-cmp',
    lazy = true,
  },
  { 'hrsh7th/nvim-compe',
    dependencies = 'GoldsteinE/compe-latex-symbols',
    config = {
      source = {
        path = true,
        buffer = true,
        tags = true,
        spell = true,
        calc = true,
        emoji = true,
        nvim_lsp = true,
        nvim_lua = true,
        latex_symbols = true,
      },
    },
  },
  { 'iamcco/markdown-preview.nvim',
    build = 'env --chdir app yarn install',
    commit = '239ea074',
    ft = 'markdown',
    config = function()
      -- Do not close the current preview when changing the buffer.
      vim.g.mkdp_auto_close = 0
    end,
  },
  { 'ibhagwan/fzf-lua',
    dependencies = {
      { 'kyazdani42/nvim-web-devicons' },
      { 'vijaymarupudi/nvim-fzf' },
    },
    config = {
      lsp = {
        code_actions = {
          winopts = { relative = 'cursor' },
        },
      },
    },
  },
  { 'jghauser/fold-cycle.nvim',
    config = true,
  },
  { 'jiangmiao/auto-pairs',
    config = function()
      -- Do not create the <M-n> shortcut to map it myself later.
      vim.g.AutoPairsShortcutJump = ''
    end,
  },
  { 'junegunn/vim-easy-align',
    config = function()
      vim.g.easy_align_delimiters = {
        ['>'] = {
          pattern = '->\\|-->\\|=>\\|==>\\|\\~>\\|\\~\\~>',
        }
      }
    end,
  },
  { 'lukas-reineke/virt-column.nvim',
    config = true,
  },
  { 'luukvbaal/stabilize.nvim',
    config = true,
  },
  { 'Maan2003/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()

      -- Disable virtual lines initially.
      vim.diagnostic.config {
        virtual_lines = false,
      }
    end,
  },
  { 'mcauley-penney/tidy.nvim',
    config = true
  },
  { 'mcchrish/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
  },
  { 'michaeljsmith/vim-indent-object' },
  { 'monaqa/dial.nvim',
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%Y-%m-%d'],
          augend.date.alias['%d.%m.%Y'],
          augend.date.alias['%d.%m.%y'],
          augend.date.alias['%m/%d'],
          augend.date.alias['%d.%m.'],
          augend.date.alias['%H:%M'],
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
        }
      }
    end,
  },
  { 'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')

      -- Bash
      lspconfig.bashls.setup {
        filetypes = { 'bash', 'sh' },
      }

      -- C, C++ and Objective C
      lspconfig.clangd.setup {}

      -- Elixir
      lspconfig.elixirls.setup {
        cmd = { '/usr/lib/elixir-ls/language_server.sh' },
      }

      -- Haskell
      lspconfig.hls.setup {
        settings = {
          haskell = {
            formattingProvider = 'stylish-haskell'
          }
        }
      }

      -- Java
      lspconfig.jdtls.setup {}

      -- Lua
      require('lspconfig').sumneko_lua.setup {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- Markdown
      lspconfig.marksman.setup {}

      -- TeX
      lspconfig.texlab.setup {
        settings = {
          texlab = {
            build = {
              -- Build with LuaLaTeX.
              args = {'-lualatex', '-interaction=nonstopmode', '-synctex=1', '%f'},
              onSave = true,
            },
            forwardSearch = {
              executable = 'okular',
              args = { '--unique', 'file:%p#src:%l%f' },
            },
          },
        },
      }
    end,
  },
  { 'norcalli/nvim-colorizer.lua',
    config = true,
  },
  { 'numToStr/Comment.nvim',
    config = true
  },
  { 'nvim-lualine/lualine.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      vim.opt.showmode = false
      local filename = { 'filename', path = 1 }
      require('lualine').setup {
        options = {
          theme = 'gruvbox-material',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_b = { 'diagnostics' },
          lualine_c = { filename },
          lualine_x = {
            'filetype',
            { 'fileformat',
              icons_enabled = true,
              symbols = {
                unix = 'LF',
                dos = 'CRlF',
                mac = 'CR',
              }
            },
          },
        },
        inactive_sections = {
          lualine_c = { filename },
        },
        extensions = {
          'drex',
          'fzf',
          'man',
          'mundo',
          'quickfix',
        }
      }
    end,
  },
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gni',
            node_decremental = 'gn[',
            node_incremental = 'gn]',
            scope_incremental = 'gns',
          },
        },
        indent = { enable = true },
        matchup = { enable = true },

        ensure_installed = { 'help', 'lua', 'vim' },

        -- Automatically install missing parsers when entering buffer.
        auto_install = false,
      }
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },
  { 'potamides/pantran.nvim',
    config = {
      default_engine = 'google'
    },
  },
  { 'rafcamlet/nvim-luapad' },
  { 'rafcamlet/tabline-framework.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = {
      render = function(f)
        f.make_tabs(function(info)
          vim.pretty_print(info)
          f.add(' ' .. info.index .. ' ')
          f.add(info.filename or '[no name]')
          f.add(info.modified and '+')
          f.add ' '
        end)
      end,
    },
  },
  { 'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  },
  { 'sainnhe/gruvbox-material',
    lazy = true,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = 'mix'
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_sign_column_background = 'grey'
      vim.g.gruvbox_material_disable_terminal_colors = 1
    end,
  },
  { 'simnalamburt/vim-mundo' },
  { 'sindrets/winshift.nvim' },
  { 'sQVe/sort.nvim',
    config = function()
      require('sort').setup()
      vim.cmd.cnoreabbrev { 'sort', 'Sort' }
    end,
  },
  { 'stefandtw/quickfix-reflector.vim' },
  { 'stevearc/dressing.nvim' },
  { 'theblob42/drex.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('drex.config').configure {
        keybindings = {
          ['n'] = {
            ['<CR>'] = '<C-^>',
            ['o'] = function() -- open a file
              local line = vim.api.nvim_get_current_line()
              local element = require('drex.utils').get_element(line)
              vim.fn.jobstart('xdg-open "' .. element .. '" &', { detach = true })
            end,
            ['L'] = function() require('drex').open_directory() end,
            ['H'] = function() require('drex').open_parent_directory() end,
            ['<C-h>'] = '<C-w>h',
            ['<C-l>'] = '<C-w>l',
            ['<C-s>'] = function() require('drex').open_file('sp') end,
          }
        },
      }

      -- Do not list drex buffers
      local augroup = vim.api.nvim_create_augroup('drex', {})
      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        pattern = 'drex',
        desc = 'Do not list drex buffers',
        callback = function()
          vim.opt_local.buflisted = false
        end
      })
    end
  },
  { 'tpope/vim-endwise' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'tweekmonster/startuptime.vim' },
  { 'Wansmer/treesj',
    config = {
      use_default_keymaps = false
    },
  },
  { 'wellle/targets.vim' },
}
