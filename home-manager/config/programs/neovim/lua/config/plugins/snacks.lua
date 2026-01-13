---@alias snacks.picker.config.modifier { pred: fun(snacks.picker.Config):boolean; config: snacks.picker.Config }

---@param sources snacks.picker.sources.Config
---@param modifiers snacks.picker.config.modifier[]
---@return snacks.picker.sources.Config
local function modify_sources(sources, modifiers)
  local all_sources = vim.tbl_deep_extend('force', require 'snacks.picker.config.sources', sources)
  local all_sources_with_defaults = {}
  for name, config in pairs(all_sources) do
    for _, mod in ipairs(modifiers) do
      if mod.pred(config) then
        all_sources_with_defaults[name] =
          vim.tbl_deep_extend('error', all_sources_with_defaults[name] or {}, mod.config)
      end
    end
  end
  return all_sources_with_defaults
end

local qflist_actions_in_file_sources = {
  pred = function(source)
    return source.format == 'file'
  end,
  config = {
    confirm = 'qflist_or_edit',
    win = {
      input = {
        keys = {
          ['<C-c>'] = { 'qflist', mode = { 'i', 'n' } },
          ['<C-l>'] = { 'loclist', mode = { 'i', 'n' } },
        },
      },
      list = {
        keys = {
          ['<C-c>'] = 'qflist',
          ['<C-l>'] = 'loclist',
        },
      },
    },
  },
}

local window_navigation = {
  keys = {
    ['<C-h>'] = { '<C-w>h', expr = true },
    ['<C-j>'] = { '<C-w>j', expr = true },
    ['<C-k>'] = { '<C-w>k', expr = true },
    ['<C-l>'] = { '<C-w>l', expr = true },
  },
}
local window_navigation_in_non_auto_close_sources = {
  pred = function(source)
    return source.auto_close == false
  end,
  config = {
    win = {
      input = window_navigation,
      list = window_navigation,
    },
  },
}

local edit = function(cmd)
  return { action = 'edit', cmd = cmd }
end

local qflist_or = function(alt_action)
  return function(picker)
    picker:action(#picker:selected() > 1 and 'qflist' or alt_action)
  end
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,

  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    }, -- TODO
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
    },
    input = {
      enabled = true,
    },
    lazygit = {
      configure = false,
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
    picker = {
      enabled = true,
      layout = {
        cycle = false,
        preset = function()
          return vim.o.columns >= 180 and 'default' or 'vertical'
        end,
      },
      win = {
        input = {
          keys = {
            ['<C-q>'] = { 'close', mode = { 'i', 'n' } },
          },
        },
        list = {
          keys = {
            ['<C-q>'] = 'close',
          },
        },
        preview = {
          keys = {
            ['<C-q>'] = 'close',
          },
        },
      },
      actions = {
        edit_split = edit 'split',
        edit_tab = edit 'tab',
        edit_vsplit = edit 'vsplit',
        qflist_or_edit = qflist_or 'edit',
        qflist_or_split = qflist_or 'edit_split',
        qflist_or_tab = qflist_or 'edit_tab',
        qflist_or_vsplit = qflist_or 'edit_vsplit',
      },
      layouts = {
        horizontal = {
          layout = {
            backdrop = 60,
          },
        },
        vertical = {
          layout = {
            backdrop = 60,
          },
        },
        vscode = {
          layout = {
            backdrop = 60,
          },
        },
      },
      sources = {
        arguments = {
          format = 'file',
          finder = function()
            local arguments = {}
            for i = 0, vim.fn.argc() - 1 do
              local arg = vim.fn.argv(i)
              local st = vim.uv.fs_stat(arg --[[@as string]])
              if st and st.type == 'file' then
                table.insert(arguments, { file = arg })
              end
            end
            return arguments
          end,
        },
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
        filetypes = {
          layout = 'vscode',
          items = vim.tbl_map(function(ft)
            return { text = ft }
          end, vim.fn.getcompletion('', 'filetype')),
          format = function(item)
            local icon, icon_hl = require('snacks.util').icon(item.text, 'filetype', {
              fallback = { file = ' ' },
            })
            return {
              { icon .. ' ', icon_hl },
              { item.text },
            }
          end,
          confirm = function(picker, item)
            picker:close()
            vim.cmd.set('filetype=' .. item.text)
          end,
        },
        grep = {
          hidden = true,
        },
        grep_buffers = {
          hidden = true,
        },
        grep_word = {
          hidden = true,
        },
      },
    },
    quickfile = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
    styles = {
      notification_history = {
        wo = {
          winhighlight = 'NormalFloat:Normal,FloatBorder:SnacksPickerBorder',
        },
      },
      scratch = {
        wo = {
          winhighlight = 'NormalFloat:Normal,FloatBorder:SnacksPickerBorder',
        },
      },
      input = {
        relative = 'cursor',
        row = -3,
        col = 0,
        keys = {
          ctrl_q = { '<C-q>', 'cancel', mode = { 'i', 'n' }, expr = true },
        },
      },
    },
    words = {
      enabled = true,
    },
  },

  config = function(_, opts)
    local merged_opts = vim.tbl_deep_extend('force', opts, {
      picker = {
        sources = modify_sources(opts.picker.sources, {
          qflist_actions_in_file_sources,
          window_navigation_in_non_auto_close_sources,
        }),
      },
    })

    require('snacks').setup(merged_opts)
  end,
}
