local opt = vim.opt_local
local util = require("util")
local tex = require("tex")

opt.colorcolumn:append("+1")
opt.comments = ":%"
opt.iskeyword:remove("_")
opt.makeprg = util.makeOr("latexmk '%'")
opt.path = vim.fn.system("kpsepath tex | sed 's/!!//g;s#/*\\(:\\|$\\)#/**\\1#g;s/:/,/g'")
opt.suffixesadd = { ".tex", ".sty", ".cls", ".ltx", ".dtx" , ".lco" }
opt.textwidth = 100
opt.define:append("\\v" -- Use magic patterns
  .. "|\\\\DeclarePairedDelimiter(X(PP)=)=\\s*{=\\s*" -- From the mathtools package
  .. "|\\\\(re)=new(operator|mathbb)\\*=\\s*{=\\s*") -- From my configuration
opt.include:append("\\v" -- Use magic patterns
  .. "|\\\\(input|usepackage|documentclass"
  .. "|(RequirePackage|Load(Package|Class))(WithOptions)=)\\s*\\{=\\s*")

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set colorcolumn< comments< define< include< iskeyword< path<" ..
  " suffixesadd< textwidth<"

-- Automatically insert $ in a pair
vim.b.AutoPairs = vim.tbl_extend("force", vim.g.AutoPairs, { ['$'] = '$' })
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| unlet b:AutoPairs"

-- Write all TeX buffers before compiling
local augroup = vim.api.nvim_create_augroup("tex", {})
vim.api.nvim_create_autocmd("QuickFixCmdPre", {
  group = augroup,
  buffer = 0,
  desc = "Write all TeX buffers before compiling",
  callback = function (args)
    vim.cmd.bufdo "if expand('%:e') =~# 'tex|sty|cls|bib' | update | endif"
    vim.api.nvim_set_current_buf(args.buf)
  end,
})

if not vim.g.no_plugin_maps then
  require("nest").applyKeymaps {
    { "<LocalLeader>", buffer = true, {
      { "v",
        "<Cmd>TexlabForward<CR>",
        desc = "View generated PDF document",
      },
      { "e",
        tex.createEnvironment,
        desc = "Create an environment",
        expr = true,
        mode = "i",
      },
    }}
  }

  vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| mapclear <buffer>"
end
