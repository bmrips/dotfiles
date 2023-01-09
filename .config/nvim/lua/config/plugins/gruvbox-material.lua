return {
  'sainnhe/gruvbox-material',
  lazy = true,
  opts = {
    better_performance = 1,
    disable_terminal_colors = 1,
    enable_bold = 1,
    enable_italic = 1,
    foreground = 'mix',
    sign_column_background = 'grey',
  },
  config = require('compat.vimscript.plugin').setup 'gruvbox_material_',
}
