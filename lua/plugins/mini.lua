local util = require 'util'
local keys = require 'keygroups'
local mini_augroup = vim.api.nvim_create_augroup('mini', { clear = true })

return {
  {
    src = util.gh 'nvim-mini/mini.ai',
    name = 'mini.ai',
    data = {
      after = function()
        require('mini.ai').setup {
          n_lines = 500,
        }
      end,
    },
  },

  {
    src = util.gh 'nvim-mini/mini.surround',
    name = 'mini.surround',
    data = {
      event = 'BufReadPost',
      after = function()
        local opts = {
          mappings = {
            add = keys.key.surround 'a',
            delete = keys.key.surround 'd',
            find = keys.key.surround 'f',
            find_left = keys.key.surround 'F',
            highlight = keys.key.surround 'h',
            replace = keys.key.surround 'r',
            update_n_lines = keys.key.surround 'n',
          },
        }
        require('mini.surround').setup(opts)
      end,
    },
  },

  {
    src = util.gh 'nvim-mini/mini.comment',
    name = 'mini.comment',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    data = {
      after = function()
        require('mini.comment').setup {
          options = {
            custom_commentstring = function()
              return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
            end,
          },
        }
      end,
    },
  },

  {
    src = util.gh 'nvim-mini/mini.bufremove',
    name = 'mini.bufremove',
    data = {
      after = function()
        require('mini.bufremove').setup {}
      end,
      keys = {
        {
          lhs = keys.key.buffer 'd',
          rhs = function()
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
          lhs = keys.key.buffer 'D',
          rhs = function()
            require('mini.bufremove').delete(0, true)
          end,
          desc = 'Delete buffer (force)',
        },
      },
    },
  },

  {
    src = util.gh 'nvim-mini/mini.indentscope',
    name = 'mini.indentscope',
    data = {
      after = function()
        require('mini.indentscope').setup {}

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
  },

  {
    src = util.gh 'nvim-mini/mini.statusline',
    name = 'mini.statusline',
    data = {
      after = function()
        local opts = {
          use_icons = vim.g.have_nerd_font,
        }
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
  },
}
