local util = require 'util'
return {
  {
    util.gh 'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font,
      },
    },
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },

      dashboard = { enabled = false },
      explorer = { enabled = false },
      lazygit = { enabled = false },
      scroll = { enabled = false },
    },
  },
  { import = 'plugins.snacks.picker' },
}
