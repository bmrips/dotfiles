opt = vim.opt_local
util = require("util")

opt.colorcolumn:append("+1")
opt.comments = ":%"
opt.commentstring = "% %s"
opt.iskeyword:remove("_")
opt.path:append("/home/bmr/texmf/tex/**", "/usr/share/texmf/tex/**")
opt.suffixesadd = { ".tex", ".sty", ".cls", ".ltx", ".dtx" , ".lco" }
opt.textwidth = 100
opt.define:append("\\v" -- Use magic patterns
    .. "|\\\\DeclarePairedDelimiter(X(PP)=)=\\s*{=\\s*" -- From the mathtools package
    .. "|\\\\(re)=new(operator|mathbb)\\*=\\s*{=\\s*") -- From my configuration
opt.include:append("\\v" -- Use magic patterns
    .. "|\\\\(input|usepackage|documentclass"
    .. "|(RequirePackage|Load(Package|Class))(WithOptions)=)\\s*\\{=\\s*")

vim.b.undo_ftplugin = vim.b.undo_ftplugin
    .. "| set colorcolumn< comments< commentstring< define< include< iskeyword< path< suffixesadd<"
    .. " textwidth<"

-- Automatically insert $ in a pair
vim.b.AutoPairs = vim.tbl_extend("force", vim.g.AutoPairs, { ['$'] = '$' })
vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| unlet b:AutoPairs"

vim.cmd "compiler! tex"

if vim.g.no_plugin_maps == nil and vim.g.no_tex_maps == nil then
    -- Open the generated PDF document
    util.buf_map("", "<LocalLeader>o", "<Cmd>TexlabForward<CR>")

    -- Shortcut to create an environment
    util.buf_map("i", "<LocalLeader>e", "luaeval('require\"tex\".createEnvironment()')", {expr = true})

    vim.b.undo_ftplugin = vim.b.undo_ftplugin .. "| mapclear <buffer>"
end
