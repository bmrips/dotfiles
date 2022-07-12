local config = {
  git = {
    subcommands = {
      -- Allow rebasing during updates.
      update = "pull --progress",
    },
  },
}

local plugins = {
  { "andymass/vim-matchup",
    config = function()
      -- Do not display off-screen matches
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }

      -- Defer highlighting to improve performance
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
  { "direnv/direnv.vim" },
  { "ellisonleao/gruvbox.nvim",
    config = function()
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_invert_selection = 0
      vim.cmd "colorscheme gruvbox"
    end,
  },
  { "f1rstlady/loupe",
    config = function()
      -- Do not center search results on n/N.
      vim.g.LoupeCenterResults = 0
    end,
  },
  { "f1rstlady/vim-unimpaired" },
  { "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  },
  { "hrsh7th/nvim-cmp",
    opt = true,
  },
  { "hrsh7th/nvim-compe",
    requires = "GoldsteinE/compe-latex-symbols",
    config = function()
      require("compe").setup {
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
      }
    end,
  },
  { "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    commit = "239ea074",
    ft = "markdown",
    config = function()
      -- Do not close the current preview when changing the buffer.
      vim.g.mkdp_auto_close = 0
    end,
  },
  { "ibhagwan/fzf-lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "vijaymarupudi/nvim-fzf",
    },
  },
  { "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup()
    end,
  },
  { "jiangmiao/auto-pairs",
    config = function()
      -- Do not create the <M-n> shortcut to map it myself later.
      vim.g.AutoPairsShortcutJump = ""
    end,
  },
  { "junegunn/goyo.vim",
    config = function()
      -- Fit the window size to the text width.
      vim.api.nvim_create_autocmd("User", {
        pattern = "GoyoEnter",
        desc = "Fit the window size to the text width",
        callback =
          function ()
            vim.cmd("Goyo " .. vim.opt_local.textwidth:get() .. "x")
          end,
      })
    end,
  },
  { "junegunn/limelight.vim" },
  { "junegunn/vim-easy-align" },
  { "LionC/nest.nvim" },
  { "lukas-reineke/virt-column.nvim",
    after = "gruvbox.nvim",
    config = function()
      require("virt-column").setup()
    end,
  },
  { "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup()
    end,
  },
  { "michaeljsmith/vim-indent-object" },
  { "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%d.%m.%Y"],
          augend.date.alias["%d.%m.%y"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%d.%m."],
          augend.date.alias["%H:%M"],
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
        }
      }
    end,
  },
  { "neovim/nvim-lspconfig" },
  { "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "nvim-lua/plenary.nvim",
    opt = true,
  },
  { "nvim-lualine/lualine.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      vim.opt.showmode = false
      require('lualine').setup {
        options = {
          theme = "gruvbox",
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_b = { "diagnostics" },
          lualine_c = {
            { "filename",
              path = 1,
              symbols = {
                modified = " +",
                readonly = " -",
              },
            },
          },
          lualine_x = {
            "filetype",
            { "fileformat",
              icons_enabled = true,
              symbols = {
                unix = "LF",
                dos = "CRlF",
                mac = "CR",
              }
            },
          },
        },
        extensions = {
          "man",
          "mundo",
          "quickfix",
        }
      }
    end,
  },
  { "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true, },
        indent = { enable = true },

        ensure_installed = { "help", "lua", "vim" },

        -- Automatically install missing parsers when entering buffer.
        auto_install = false,
      }
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  { "rafcamlet/nvim-luapad" },
  { "rainbowhxch/beacon.nvim" },
  { "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },
  { "sQVe/sort.nvim",
    config = function()
      require("sort").setup()
      vim.cmd "cnoreabbrev sort Sort"
    end,
  },
  { "simnalamburt/vim-mundo" },
  { "sindrets/winshift.nvim" },
  { "stefandtw/quickfix-reflector.vim" },
  { "stevearc/dressing.nvim" },
  { "tpope/vim-endwise" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tweekmonster/startuptime.vim" },
  { "wbthomason/packer.nvim" },
  { "wellle/targets.vim" },
  { "zdharma-continuum/zinit-vim-syntax" },
}

return require("packer").startup { plugins, config = config }
