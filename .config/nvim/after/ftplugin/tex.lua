opt = vim.opt_local
util = require("util")

opt.colorcolumn:append("+1")
opt.comments = ":%"
opt.commentstring = "% %s"
opt.iskeyword:remove("_")
opt.makeprg = "latexmk '%'"
opt.path:append("/home/bmr/texmf/tex/**", "/usr/share/texmf/tex/**")
opt.suffixesadd = { ".tex", ".sty", ".cls", ".ltx", ".dtx" , ".lco" }
opt.textwidth = 100
opt.define:append("\\v" -- Use magic patterns
  .. "|\\\\DeclarePairedDelimiter(X(PP)=)=\\s*{=\\s*" -- From the mathtools package
  .. "|\\\\(re)=new(operator|mathbb)\\*=\\s*{=\\s*") -- From my configuration
opt.include:append("\\v" -- Use magic patterns
  .. "|\\\\(input|usepackage|documentclass"
  .. "|(RequirePackage|Load(Package|Class))(WithOptions)=)\\s*\\{=\\s*")

vim.b.undo_ftplugin = vim.b.undo_ftplugin ..
  "| set colorcolumn< comments< commentstring< define< include< iskeyword< path< suffixesadd<" ..
  " textwidth<"

-- Automatically insert $ in a pair
vim.b.AutoPairs = vim.tbl_extend("force", vim.g.AutoPairs, { ['$'] = '$' })
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| unlet b:AutoPairs"

-- Write all TeX buffers before compiling
vim.api.nvim_create_augroup("tex", {})
vim.api.nvim_create_autocmd("QuickFixCmdPre", {
  group = "tex",
  buffer = 0,
  desc = "Write all TeX buffers before compiling",
  callback =
    function ()
      local curbuf = vim.api.nvim_win_get_buf(0)
      vim.cmd "bufdo if expand('%:e') =~# 'tex\\|sty\\|cls\\|bib' | update | endif"
      vim.api.nvim_win_set_buf(curbuf)
    end,
})

if not vim.g.no_plugin_maps then
  require("nest").applyKeymaps {
    { "<LocalLeader>", buffer = true, {
      -- Open the generated PDF document.
      { "o", "<Cmd>TexlabForward<CR>" },

      -- Create an environment.
      { "e", require("tex").createEnvironment, mode = "i", options = {expr = true} }
    }}
  }

  vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| mapclear <buffer>"
end
