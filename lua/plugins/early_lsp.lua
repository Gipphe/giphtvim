local util = require 'util'

return {
  {
    name = 'lazydev.nvim',
    pack = {
      src = util.gh 'folke/lazydev.nvim',
    },
    enabled = nixInfo(false, 'settings', 'cats', 'lsp') and nixInfo(false, 'settings', 'cats', 'lua'),
    ft = 'lua',
    after = function()
      ---@module 'lazydev'
      ---@type lazydev.Config
      local opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          { words = { 'nixInfo%.lze' }, path = nixInfo('lze', 'plugins', 'start', 'lze') .. '/lua' },
          { words = { 'nixInfo%.lze' }, path = nixInfo('lzextras', 'plugins', 'start', 'lzextras') .. '/lua' },
        },
      }
      require('lazydev').setup(opts)
    end,
    on_require = {
      'lazydev',
      'lazydev.integrations.blink',
    },
  },
}
