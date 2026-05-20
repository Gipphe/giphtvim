local util = require 'util'

return {
  {
    src = util.gh 'nvim-lua/plenary.nvim',
    name = 'plenary',
  },
  {
    src = util.gh 'nvim-tree/nvim-web-devicons',
    data = {
      lazy = false,
      after = function()
        require('nvim-web-devicons').setup {}
      end,
    },
  },
}
