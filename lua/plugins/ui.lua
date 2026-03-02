local catUtils = require 'nixCatsUtils'
local util = require 'util'
local keys = require 'keygroups'
local icons = util.icons

return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-mini/mini.bufremove',
    },
    ---@module 'bufferline'
    ---@type bufferline.UserConfig
    opts = {
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
    },
    event = 'VeryLazy',
    keys = function(_, old_keys)
      old_keys = old_keys or {}
      local k = function(l, r, desc)
        return { keys.key.buffer(l), r, desc = desc }
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
  },

  {
    'catppuccin/nvim',
    name = require('nixCatsUtils').lazyAdd('catppuccin', 'catppuccin-nvim'),
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
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
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },

  {
    'gelguy/wilder.nvim',
    opts = {
      modes = {
        '/',
        '?',
        ':',
      },
    },
  },

  {
    'swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<C-h>', '<cmd>ZellijNavigateLeftTab<cr>', desc = 'Navigate left' },
      { '<C-l>', '<cmd>ZellijNavigateRightTab<cr>', desc = 'Navigate right' },
      { '<C-j>', '<cmd>ZellijNavigateDown<cr>', desc = 'Navigate down' },
      { '<C-k>', '<cmd>ZellijNavigateUp<cr>', desc = 'Navigate up' },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@type fun(_: any, opts: wk.Spec): wk.Spec
    opts = util.concat_opts(require('keygroups').which_key),
    config = function(_, spec)
      require('which-key').setup()
      require('which-key').add(spec)
    end,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPost',
    opts = {},
    dependencies = {
      'saghen/blink.cmp',
      opts = {
        completion = {
          menu = {
            draw = {
              components = {
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if ctx.item.source_name == 'LSP' then
                      local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                      if color_item and color_item.abbr ~= '' then
                        icon = color_item.abbr
                      end
                    end
                    return icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                    local highlight = 'BlinkCmpKind' .. ctx.kind
                    if ctx.item.source_name == 'LSP' then
                      local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                      if color_item and color_item.abbr_hl_group then
                        highlight = color_item.abbr_hl_group
                      end
                    end
                    return highlight
                  end,
                },
              },
            },
          },
        },
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    enabled = catUtils.cat('rich_ui', false),
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@type TodoOptions
    opts = {
      signs = false,
    },
    keys = util.concat_opts(function()
      local k = keys.key

      return {
        {
          k.next 't',
          function()
            require('todo-comments').jump_next()
          end,
          desc = 'Next todo comment',
        },
        {
          k.prev 't',
          function()
            require('todo-comments').jump_prev()
          end,
          desc = 'Previous todo comment',
        },
        {
          k.diagnostic 't',
          '<cmd>TodoTrouble<cr>',
          desc = 'Todo (Trouble)',
        },
        {
          k.diagnostic 'T',
          '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>',
          desc = 'Todo/Fix/Fixme (Trouble)',
        },
        {
          k.diagnostic 'c',
          function()
            ---@diagnostic disable-next-line: undefined-field
            require('snacks').picker.todo_comments()
          end,
          desc = 'Todo',
        },
        {
          k.diagnostic 'C',
          function()
            ---@diagnostic disable-next-line: undefined-field
            require('snacks').picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
          end,
          desc = 'Todo/Fix/Fixme',
        },
      }
    end),
  },
}
