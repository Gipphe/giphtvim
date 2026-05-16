local util = require 'util'

return {
  {
    'snacks.nvim',
    pack = {
      src = util.gh 'folke/snacks.nvim',
    },
    lazy = false,
    priority = 1000,
    after = function()
      ---@type snacks.Config
      local opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        picker = {},

        dashboard = { enabled = false },
        explorer = { enabled = false },
        lazygit = { enabled = false },
        scroll = { enabled = false },
      }
      require('snacks').setup(opts)
    end,
    keys = require('plugins.snacks.picker').keys,
  },
}
