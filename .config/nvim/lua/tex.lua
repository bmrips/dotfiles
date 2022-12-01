local tex = {}

-- Insert an environment, whose name is given interactively by the user.
tex.createEnvironment = function()
  local env = vim.fn.input("Environment: ")
  if env ~= '' then
    return "\\begin{"..env.."}\n\\end{"..env.."}<Up><C-o>A<C-g>u"
  else
    return ''
  end
end

return tex
