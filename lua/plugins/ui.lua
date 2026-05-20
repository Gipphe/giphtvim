local util = require 'util'
local keys = require 'keygroups'
local icons = util.icons

return {
  {
    'bufferline.nvim',
    pack = {
      src = util.gh 'akinsho/bufferline.nvim',
    },
    event = 'DeferredUIEnter',
    keys = function(_, old_keys)
      old_keys = old_keys or {}
      local k = function(l, r, desc)
        return { lhs = keys.key.buffer(l), rhs = r, desc = desc }
      end
      local new_keys = {
        k('p', '<Cmd>BufferLineTogglePin<CR>', 'Toggle pin'),
        k('P', '<Cmd>BufferLineGroupClose ungrouped<CR>', 'Delete non-pinned buffers'),
        k('o', '<Cmd>BufferLineCloseOthers<CR>', 'Delete other buffers'),
        k('r', '<Cmd>BufferLineCloseRight<CR>', 'Delete buffers to the right'),
        k('l', '<Cmd>BufferLineCloseLeft<CR>', 'Delete buffers to the left'),
        { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
        { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      }
      return util.flatten(old_keys, new_keys)
    end,
    after = function()
      ---@module 'bufferline'
      ---@type bufferline.UserConfig
      local opts = {
        options = {
          close_command = function(n)
            require('mini.bufremove').delete(n, false)
          end,
          right_mouse_command = function(n)
            require('mini.bufremove').delete(n, false)
          end,
          diagnostics = 'nvim_lsp',
          always_show_bufferline = true,
          diagnostics_indicator = function(_, _, diag)
            local ret = (diag.error and icons.diagnostics.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.diagnostics.Warn .. diag.warning or '')
            return vim.trim(ret)
          end,
        },
      }
      require('bufferline').setup(opts)
    end,
  },

  {
    nixInfo.isNix and 'catppuccin-nvim' or 'catppuccin',
    pack = {
      name = 'catppuccin-nvim',
      src = util.gh 'catppuccin/nvim',
    },
    colorscheme = {
      'catppuccin-frappe',
      'catppuccin-latte',
      'catppuccin-macchiato',
      'catppuccin-mocha',
      'catppuccin-nvim',
      'catppuccin',
    },
    after = function()
      require('catppuccin').setup {
        flavour = 'macchiato',
        show_end_of_buffer = true,
        integrations = {
          cmp = true,
          flash = true,
          gitsigns = true,
          illuminate = {
            enabled = true,
          },
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          mini = {
            enabled = true,
          },
          native_lsp = {
            enabled = true,
          },
          noice = true,
          notify = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
      }
    end,
  },

  {
    'colorscheme',
    event = 'VimEnter',
    load = function()
      vim.schedule(function()
        vim.cmd.colorscheme(nixInfo('catppuccin-macchiato', 'settings', 'colorscheme'))
        vim.schedule(function()
          vim.cmd [[hi LineNr guifg=#a887e3]]
        end)
      end)
    end,
  },

  {
    'wilder.nvim',
    pack = {
      src = util.gh 'gelguy/wilder.nvim',
    },
    lazy = false,
    after = function()
      require('wilder').setup {
        modes = {
          '/',
          '?',
          ':',
        },
      }
    end,
  },

  {
    'zellij-nav.nvim',
    pack = {
      src = util.gh 'swaits/zellij-nav.nvim',
    },
    after = function()
      require('zellij-nav').setup {}
    end,
    keys = {
      {
        lhs = '<C-h>',
        rhs = '<cmd>ZellijNavigateLeftTab<cr>',
        desc = 'Navigate left',
      },
      {
        lhs = '<C-l>',
        rhs = '<cmd>ZellijNavigateRightTab<cr>',
        desc = 'Navigate right',
      },
      {
        lhs = '<C-j>',
        rhs = '<cmd>ZellijNavigateDown<cr>',
        desc = 'Navigate down',
      },
      {
        lhs = '<C-k>',
        rhs = '<cmd>ZellijNavigateUp<cr>',
        desc = 'Navigate up',
      },
    },
  },

  {
    'which-key.nvim',
    pack = {
      src = util.gh 'folke/which-key.nvim',
    },
    event = 'VimEnter',
    after = function()
      require('which-key').setup()
      require('which-key').add(require('keygroups').which_key)
    end,
  },

  {
    'nvim-highlight-colors',
    pack = {
      src = util.gh 'brenoprata10/nvim-highlight-colors',
    },
    event = 'BufReadPost',
    after = function()
      require('nvim-highlight-colors').setup {}
    end,
  },

  {
    'todo-comments.nvim',
    pack = {
      src = util.gh 'folke/todo-comments.nvim',
    },
    enabled = nixInfo(false, 'settings', 'cats', 'rich_ui'),
    event = 'VimEnter',
    after = function()
      ---@type TodoOptions
      local opts = {
        signs = false,
      }
      require('todo-comments').setup(opts)
    end,
    keys = {
      {
        lhs = keys.key.next 't',
        rhs = function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        lhs = keys.key.prev 't',
        rhs = function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
      {
        lhs = keys.key.diagnostic 't',
        rhs = '<cmd>TodoTrouble<cr>',
        desc = 'Todo (Trouble)',
      },
      {
        lhs = keys.key.diagnostic 'T',
        rhs = '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>',
        desc = 'Todo/Fix/Fixme (Trouble)',
      },
      {
        lhs = keys.key.diagnostic 'c',
        rhs = function()
          ---@diagnostic disable-next-line: undefined-field
          require('snacks').picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        lhs = keys.key.diagnostic 'C',
        rhs = function()
          ---@diagnostic disable-next-line: undefined-field
          require('snacks').picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
}
