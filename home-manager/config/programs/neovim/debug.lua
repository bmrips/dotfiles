-- ###########################################
-- ### USAGE: nvim --clean -u template.lua ###
-- ###########################################

local root = vim.fn.stdpath 'run' .. '/nvim/minimal_working_example.nvim'
vim.fn.mkdir(root, 'p')

-- set stdpaths to use root
for _, name in ipairs { 'config', 'data', 'state', 'cache' } do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

-- remove root after exit
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.fn.delete(root, 'rf')
  end,
})

-- bootstrap lazy
local lazypath = root .. '/plugins/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

local plugins = {
  -- ##################################################################
  -- ### ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE ###
  -- ##################################################################
}
require('lazy').setup(plugins, { root = root .. '/plugins' })
require('lazy').sync { show = false, wait = true }

-- ############################################################################
-- ### ADD INIT.LUA SETTINGS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE ###
-- ############################################################################
