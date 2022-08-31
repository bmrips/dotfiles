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
  { "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup()
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
  { "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end
  },
  { "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup()
    end
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
      require("fold-cycle").setup()
    end,
  },
  { "jiangmiao/auto-pairs",
    config = function()
      -- Do not create the <M-n> shortcut to map it myself later.
      vim.g.AutoPairsShortcutJump = ""
    end,
  },
  { "junegunn/vim-easy-align" },
  { 'lewis6991/impatient.nvim' },
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
      require("tidy").setup()
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

      local on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        require("nest").applyKeymaps {
          { buffer = true, {
            { "K", vim.lsp.buf.hover },
            { "g", {
              { "d", vim.lsp.buf.definition },
              { "D", vim.lsp.buf.declaration },
              { "i", vim.lsp.buf.implementation },
              { "r", vim.lsp.buf.references },
              { "t", vim.lsp.buf.type_definition },
            }},
            { "<Leader>", {
              { "a", vim.lsp.buf.code_action },
              { "f", vim.lsp.buf.formatting },
              { "k", vim.lsp.buf.signature_help },
              { "r", vim.lsp.buf.rename },
              { "w", {
                { "a", vim.lsp.buf.add_workspace_folder },
                { "l", function()
                  vim.pretty_print(vim.lsp.buf.list_workspace_folders())
                end,
                },
                { "r", vim.lsp.buf.remove_workspace_folder },
              }},
            }},
          }}
        }
      end

      -- Bash
      lspconfig.bashls.setup {
        on_attach = on_attach,
        filetypes = { "bash", "sh" },
      }

      -- C, C++ and Objective C
      lspconfig.clangd.setup {
        on_attach = on_attach,
      }

      -- Haskell
      lspconfig.hls.setup {
        on_attach = on_attach,
        settings = {
          haskell = {
            formattingProvider = "stylish-haskell"
          }
        }
      }

      -- Lua
      require'lspconfig'.sumneko_lua.setup {
        on_attach = on_attach,
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
      lspconfig.marksman.setup {
        on_attach = on_attach,
      }

      -- TeX
      lspconfig.texlab.setup {
        on_attach = on_attach,
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

      -- Set 'signcolumn' for filetypes with a language server.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash",
          "c",
          "cpp",
          "haskell",
          "lua",
          "markdown",
          "objc",
          "objcpp",
          "sh",
          "tex"
        },
        desc = "Set 'signcolumn' for filetypes with a language server",
        callback = function()
          vim.opt_local.signcolumn = "yes"
        end,
      })
    end,
  },
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
          "drex",
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
  { 'theblob42/drex.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require("drex.config").configure {
        hijack_netrw = true,
        keybindings = {
          ["n"] = {
            ['<CR>'] = "<C-^>",
            ['o'] = function() -- open a file
                local line = vim.api.nvim_get_current_line()
                local element = require('drex.utils').get_element(line)
                vim.fn.jobstart("xdg-open '" .. element .. "' &", { detach = true })
            end,
            ['L'] = function() require("drex").open_directory() end,
            ['H'] = function() require("drex").open_parent_directory() end,
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
