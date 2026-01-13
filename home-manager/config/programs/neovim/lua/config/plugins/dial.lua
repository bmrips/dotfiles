return {
  'monaqa/dial.nvim',
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.date.alias['%Y-%m-%d'],
        augend.date.alias['%d.%m.%Y'],
        augend.date.alias['%d.%m.%y'],
        augend.date.alias['%m/%d'],
        augend.date.alias['%d.%m.'],
        augend.date.alias['%H:%M'],
        augend.constant.alias.de_weekday,
        augend.constant.alias.de_weekday_full,
      },
    }
  end,
}
