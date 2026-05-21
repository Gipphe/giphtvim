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
    cmd = {
      'BufferLineTogglePin',
      'BufferLineGroupClose',
      'BufferLineCloseOthers',
      'BufferLineCloseRight',
      'BufferLineCloseLeft',
      'BufferLineCyclePrev',
      'BufferLineCycleNext',
    },
    keys = {
      {
        lhs = keys.key.buffer 'p',
        rhs = '<Cmd>BufferLineTogglePin<CR>',
        desc = 'Toggle pin',
      },
      {
        lhs = keys.key.buffer 'P',
        rhs = '<Cmd>BufferLineGroupClose ungrouped<CR>',
        desc = 'Delete non-pinned buffers',
      },
      {
        lhs = keys.key.buffer 'o',
        rhs = '<Cmd>BufferLineCloseOthers<CR>',
        desc = 'Delete other buffers',
      },
      {
        lhs = keys.key.buffer 'r',
        rhs = '<Cmd>BufferLineCloseRight<CR>',
        desc = 'Delete buffers to the right',
      },
      {
        lhs = keys.key.buffer 'l',
        rhs = '<Cmd>BufferLineCloseLeft<CR>',
        desc = 'Delete buffers to the left',
      },
      {
        lhs = '<S-h>',
        rhs = '<cmd>BufferLineCyclePrev<cr>',
        desc = 'Prev buffer',
      },
      {
        lhs = '<S-l>',
        rhs = '<cmd>BufferLineCycleNext<cr>',
        desc = 'Next buffer',
      },
    },
    after = function()
      require('bufferline').setup {
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
