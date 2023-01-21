return {
  'rafcamlet/tabline-framework.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    render = function(f)
      f.make_tabs(function(info)
        f.add(' ' .. info.index .. ' ')
        f.add(info.filename or '[no name]')
        f.add(info.modified and '+')
        f.add ' '
      end)
    end,
  },
}
