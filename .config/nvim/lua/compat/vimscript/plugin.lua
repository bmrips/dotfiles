local plugin = {}

-- Create a `function(plugin)` that sets a table of plugin options to global
-- vimscript variables.  The options have to be specified via the `plugin.opts`
-- key as a table and are assigned to global vimscript variables via
-- `compat.vimscript.dict_to_vars_with_prefix`.  If `config.recurse` is true,
-- `compat.vimscript.dict_to_vars_rec_with_prefix` is used instead.
function plugin.setup(prefix, config)
  local cfg = config or {}
  local vimscript = require 'compat.vimscript'

  if cfg.recurse then
    return function(plg)
      vimscript.dict_to_vars_rec_with_prefix(prefix, plg.opts)
    end
  else
    return function(plg)
      vimscript.dict_to_vars_with_prefix(prefix, plg.opts)
    end
  end
end

return plugin
