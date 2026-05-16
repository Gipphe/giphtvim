local util = require 'util'

return {
  {
    'plenary.nvim',
    pack = {
      src = util.gh 'nvim-lua/plenary.nvim',
    },
  },
  {
    'nvim-web-devicons',
    pack = {
      src = util.gh 'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    after = function()
      require('nvim-web-devicons').setup {}
    end,
  },
}
