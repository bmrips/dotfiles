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
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }

      -- Defer highlighting to improve performance
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_transmute_enabled = 1
    end,
  },
  { "direnv/direnv.vim" },
  { "ellisonleao/gruvbox.nvim",
    config = function()
      vim.cmd.colorscheme "gruvbox"
    end,
  },
  { "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup()
    end,
  },
  { "f1rstlady/vim-loupe",
    config = function()
      -- Do not center search results on n/N.
      vim.g.LoupeCenterResults = 0
    end,
  },
  { "f1rstlady/vim-unimpaired" },
  { "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        operators = {
          ga = "Align"
        },
      }
    end
  },
  { "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
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
      { "kyazdani42/nvim-web-devicons" },
      { "vijaymarupudi/nvim-fzf" },
    },
  },
  { "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup {}
    end,
  },
  { "jiangmiao/auto-pairs",
    config = function()
      -- Do not create the <M-n> shortcut to map it myself later.
      vim.g.AutoPairsShortcutJump = ""
    end,
  },
  { "junegunn/vim-easy-align" },
  { "lewis6991/impatient.nvim" },
  { "LionC/nest.nvim" },
  { "lukas-reineke/virt-column.nvim",
    after = "gruvbox.nvim",
    config = function()
      require("virt-column").setup {}
    end,
  },
  { "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup {}
    end,
  },
  { "Maan2003/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()

      -- Disable virtual lines initially.
      vim.diagnostic.config {
        virtual_lines = false,
      }
    end,
  },
  { "mcauley-penney/tidy.nvim",
    config = function()
      require("tidy").setup {}
    end
  },
  { "michaeljsmith/vim-indent-object" },
  { "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
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
  { "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Bash
      lspconfig.bashls.setup {
        filetypes = { "bash", "sh" },
      }

      -- C, C++ and Objective C
      lspconfig.clangd.setup {}

      -- Haskell
      lspconfig.hls.setup {
        settings = {
          haskell = {
            formattingProvider = "stylish-haskell"
          }
        }
      }

      -- Lua
      require("lspconfig").sumneko_lua.setup {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
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
              args = {"-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f"},
              onSave = true,
            },
            forwardSearch = {
              executable = "okular",
              args = { "--unique", "file:%p#src:%l%f" },
            },
          },
        },
      }
    end,
  },
  { "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {}
    end,
  },
  { "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {}
    end
  },
  { "nvim-lua/plenary.nvim",
    opt = true,
  },
  { "nvim-lualine/lualine.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      vim.opt.showmode = false
      local filename = { "filename", path = 1 }
      require("lualine").setup {
        options = {
          theme = "gruvbox",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_b = { "diagnostics" },
          lualine_c = { filename },
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
        inactive_sections = {
          lualine_c = { filename },
        },
        extensions = {
          "drex",
          "fzf",
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
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gni",
            node_decremental = "gn[",
            node_incremental = "gn]",
            scope_incremental = "gns",
          },
        },
        indent = { enable = true },
        matchup = { enable = true },

        ensure_installed = { "help", "lua", "vim" },

        -- Automatically install missing parsers when entering buffer.
        auto_install = false,
      }
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  { "rafcamlet/nvim-luapad" },
  { "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },
  { "sQVe/sort.nvim",
    config = function()
      require("sort").setup {}
      vim.cmd.cnoreabbrev { "sort", "Sort" }
    end,
  },
  { "simnalamburt/vim-mundo" },
  { "sindrets/winshift.nvim" },
  { "stefandtw/quickfix-reflector.vim" },
  { "stevearc/dressing.nvim" },
  { "theblob42/drex.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("drex.config").configure {
        hijack_netrw = true,
        keybindings = {
          ["n"] = {
            ["<CR>"] = "<C-^>",
            ["o"] = function() -- open a file
                local line = vim.api.nvim_get_current_line()
                local element = require("drex.utils").get_element(line)
                vim.fn.jobstart("xdg-open '" .. element .. "' &", { detach = true })
            end,
            ["L"] = function() require("drex").open_directory() end,
            ["H"] = function() require("drex").open_parent_directory() end,
            ["<C-h>"] = "<C-w>h",
            ["<C-l>"] = "<C-w>l",
            ["<C-s>"] = function() require("drex").open_file("sp") end,
          }
        },
      }

      -- Do not list drex buffers
      local augroup = vim.api.nvim_create_augroup("drex", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "drex",
        desc = "Do not list drex buffers",
        callback = function()
          vim.opt_local.buflisted = false
        end
      })
    end
  },
  { "tpope/vim-endwise" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tweekmonster/startuptime.vim" },
  { "wbthomason/packer.nvim" },
  { "wellle/targets.vim" },
}

return require("packer").startup { plugins, config = config }
