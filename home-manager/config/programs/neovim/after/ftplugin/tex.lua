local opt = vim.opt_local
local file = require 'util.file'
local tex = require 'util.filetype.tex'

opt.breakindentopt = {}
opt.comments = ':%'
opt.iskeyword:remove '_'
opt.makeprg = file.makeOr "latexmk '%'"
opt.path = vim.fn.system [[
  kpsepath tex |
    sed 's/!!//g' |
    xargs -d: ls -1d 2>/dev/null |
    sed -E 's/^\.$//g;s#/{2,}(:|$)#/**\1#g' |
    tr '\n' ,
]]
opt.showbreak = ''
opt.suffixesadd = { '.tex', '.sty', '.cls', '.ltx', '.dtx', '.lco' }
opt.textwidth = 100
opt.define:append [[
\v
\\DeclarePairedDelimiter(X(PP)=)=\s*\{=\s*
|\\(re)=new(operator|mathbb)\*=\s*\{=\s*
]]
opt.include:append [[
\v\\(input|usepackage|documentclass|(RequirePackage|Load(Package|Class))(WithOptions)=)\s*\{
]]

vim.b.undo_ftplugin = vim.b.undo_ftplugin
  .. '| set breakindentopt< comments< define< include< iskeyword< path< showbreak< suffixesadd< textwidth<'

local augroup = vim.api.nvim_create_augroup('tex', { clear = false })

-- Compile documents on save
if tex.bufIsDocument(0) then
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = augroup,
    buffer = 0,
    desc = 'Compile the document on save',
    callback = function()
      vim.api.nvim_exec_autocmds('QuickFixCmdPre', {
        pattern = vim.api.nvim_buf_get_name(0),
      })
      if vim.cmd.TexlabBuild then
        vim.cmd.TexlabBuild()
      else
        vim.cmd.make { bang = true }
      end
    end,
  })
end

-- Write all TeX buffers before compiling
vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  group = augroup,
  buffer = 0,
  desc = 'Write all TeX buffers before compiling',
  callback = function(args)
    vim.cmd.bufdo 'if expand("%:e") =~# "tex|sty|cls|bib|pgf" | update | endif'
    vim.api.nvim_set_current_buf(args.buf)
  end,
})

-- stylua: ignore
require('nest').applyKeymaps {
  { buffer = true, {
    { '<LocalLeader>', {
      { '<C-e>',
        '<Cmd>TexlabChangeEnvironment<CR>',
        desc = 'Change environment',
      },
      { 'v',
        '<Cmd>TexlabForward<CR>',
        desc = 'View generated PDF document',
      },
    }},
    { '<C-e>',
      function()
        vim.ui.input({ prompt = 'Environment: ' }, tex.createEnvironment)
      end,
      desc = 'Create an environment',
      mode = 'i',
    },
  }},
}

vim.b.undo_ftplugin = vim.b.undo_ftplugin .. '| mapclear <buffer>'
