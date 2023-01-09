return {
  { 'andymass/vim-matchup',
    opts = {
      -- Do not display off-screen matches
      matchparen_offscreen = { method = 'status_manual' },

      -- Defer highlighting to improve performance
      matchparen_deferred = 1,
      transmute_enabled = 1,
    },
    config = require('compat.vimscript.plugin').setup 'matchup_',
  },
  { 'ellisonleao/gruvbox.nvim' },
  { 'ethanholz/nvim-lastplace',
    config = true,
  },
  { 'f1rstlady/display-motions.nvim' },
  { 'f1rstlady/nest.nvim' },
  { 'f1rstlady/session.nvim' },
  { 'f1rstlady/vim-loupe',
    opts = {
      CenterResults = 0,
    },
    config = require('compat.vimscript.plugin').setup 'Loupe',
  },
  { 'f1rstlady/vim-unimpaired' },
  { 'folke/lazy.nvim' },
  { 'folke/trouble.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = true,
  },
  { 'folke/which-key.nvim',
    opts = {
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
    opts = {
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
    opts = {
      -- Do not close the current preview when changing the buffer.
      auto_close = 0
    },
    config = require('compat.vimscript.plugin').setup 'mkdp_',
  },
  { 'ibhagwan/fzf-lua',
    dependencies = {
      { 'kyazdani42/nvim-web-devicons' },
      { 'vijaymarupudi/nvim-fzf' },
    },
    opts = {
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
    opts = {
      -- Do not create the <M-n> shortcut to map it myself later.
      ShortcutJump = '',
    },
    config = require('compat.vimscript.plugin').setup 'AutoPairs',
  },
  { 'junegunn/vim-easy-align',
    opts = {
      delimiters = {
        ['>'] = {
          pattern = '->\\|-->\\|=>\\|==>\\|\\~>\\|\\~\\~>',
        }
      },
    },
    config = require('compat.vimscript.plugin').setup('easy_align_', {recurse = true}),
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
    dependencies = 'folke/neodev.nvim',
    opts = {
      bashls = {
        filetypes = { 'bash', 'sh' },
      },
      clangd = {},
      elixirls = {
        cmd = { '/usr/lib/elixir-ls/language_server.sh' },
      },
      hls = {
        settings = {
          haskell = {
            formattingProvider = 'stylish-haskell',
          },
        },
      },
      jdtls = {},
      marksman = {},
      sumneko_lua = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      },
      texlab = {
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
      },
    },
    config = function(_, opts)
      for server, config in pairs(opts) do
        require('lspconfig')[server].setup(config)
      end
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
    opts = {
      options = {
        theme = 'gruvbox-material',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_b = { 'diagnostics' },
        lualine_c = { {'filename', path = 1} },
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
        lualine_c = { {'filename', path = 1} },
      },
      extensions = {
        'drex',
        'fzf',
        'man',
        'mundo',
        'quickfix',
      }
    },
    config = function(_, opts)
      require('lualine').setup(opts)
      vim.opt.showmode = false
    end,
  },
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
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
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },
  { 'potamides/pantran.nvim',
    opts = {
      default_engine = 'google'
    },
  },
  { 'rafcamlet/nvim-luapad' },
  { 'rafcamlet/tabline-framework.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    opts = {
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
    opts = {
      better_performance = 1,
      disable_terminal_colors = 1,
      enable_bold = 1,
      enable_italic = 1,
      foreground = 'mix',
      sign_column_background = 'grey',
    },
    config = require('compat.vimscript.plugin').setup 'gruvbox_material_',
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
    opts = {
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
    },
    config = function(_, opts)
      require('drex.config').configure(opts)

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
    opts = {
      use_default_keymaps = false
    },
  },
  { 'wellle/targets.vim' },
}
