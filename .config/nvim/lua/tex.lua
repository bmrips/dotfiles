util = require("util")

local M = {}

function M.createEnvironment()
    env = vim.fn.input("Environment: ")
    if env ~= '' then
        return "\\begin{" .. env .. "}\n\\end{" .. env .. util.tc("}<Up><C-o>A<C-g>u")
    else
        return ''
    end
end

return M
