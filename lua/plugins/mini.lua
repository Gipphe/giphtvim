-- Collection of various small independent plugins/modules

local mini_augroup = vim.api.nvim_create_augroup('mini', { clear = true })

return {
  {
    'nvim-mini/mini.ai',
    version = false,
    opts = {
      n_lines = 500,
    },
  },

  {
    'nvim-mini/mini.surround',
    version = false,
    event = 'BufReadPost',
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    },
  },

  {
    'nvim-mini/mini.pairs',
    version = false,
    opts = {},
    init = function()
      vim.g.minipairs_disable = true
    end,
    keys = {
      {
        '<leader>up',
        function()
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            print 'Disabled auto pairs'
          else
            print 'Enable auto pairs'
          end
        end,
        desc = 'Toggle auto pairs',
      },
    },
  },

  {
    'nvim-mini/mini.comment',
    version = false,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },

  {
    'nvim-mini/mini.bufremove',
    version = false,
    opts = {},
    keys = {
      {
        '<leader>bd',
        function()
          local bd = require('mini.bufremove').delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = 'Delete buffer',
      },
      {
        '<leader>bD',
        function()
          require('mini.bufremove').delete(0, true)
        end,
        desc = 'Delete buffer (force)',
      },
    },
  },

  {
    'nvim-mini/mini.indentscope',
    version = false,
    opts = {},
    config = function(_, opts)
      require('mini.indentscope').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        group = mini_augroup,
        pattern = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    'nvim-mini/mini.statusline',
    version = false,
    opts = {
      use_icons = vim.g.have_nerd_font,
    },
    config = function(_, opts)
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup(opts)

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v (%p%%)'
      end
    end,
  },
}
