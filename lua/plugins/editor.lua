local util = require 'util'
local keys = require 'keygroups'
local catUtils = require 'nixCatsUtils'
return {
  {
    src = util.gh 'folke/trouble.nvim',
    name = 'trouble.nvim',
    enabled = nixInfo(false, 'settings', 'cats', 'rich_editor'),
    data = {
      cmd = 'Trouble',
      after = function()
        require('trouble.nvim').setup {}
      end,
      keys = {
        {
          lhs = keys.key.diagnostic 'x',
          rhs = '<cmd>Trouble diagnostics toggle<cr>',
          desc = 'Diagnostics (Trouble)',
        },
        {
          lhs = keys.key.diagnostic 'X',
          rhs = '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
          desc = 'Buffer Diagnostics (Trouble)',
        },
        {
          lhs = keys.key.diagnostic 'L',
          rhs = '<cmd>Trouble loclist toggle<cr>',
          desc = 'Location List (Trouble)',
        },
        {
          lhs = keys.key.diagnostic 'Q',
          rhs = '<cmd>Trouble qflist toggle<cr>',
          desc = 'Quickfix List (Trouble)',
        },
        {
          lhs = keys.key.code 's',
          rhs = '<cmd>Trouble symbols toggle focus=false<cr>',
          desc = 'Symbols (Trouble)',
        },
        {
          lhs = keys.key.code 'x',
          rhs = '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
          desc = 'LSP Definitions / references / ... (Trouble)',
        },

        {
          lhs = keys.key.prev 'q',
          rhs = function()
            if require('trouble').is_open() then
              require('trouble').previous { skip_groups = true, jump = true }
            else
              local ok, err = pcall(vim.cmd.cprev)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          desc = 'Previous Trouble/Quickfix Item',
        },
        {
          lhs = keys.key.next 'q',
          rhs = function()
            if require('trouble').is_open() then
              ---@diagnostic disable-next-line: missing-parameter
              require('trouble').next { skip_groups = true, jump = true }
            else
              local ok, err = pcall(vim.cmd.cnext)
              if not ok then
                vim.notify(err, vim.log.levels.ERROR)
              end
            end
          end,
          desc = 'Next Trouble/Quickfix Item',
        },
      },
    },
  },
  {
    src = util.gh 'nvim-pack/nvim-spectre',
    enabled = nixInfo(false, 'settings', 'cats', 'rich_editor'),
    data = {
      after = function()
        require('nvim-spectre').setup {}
      end,
      keys = {
        {
          lhs = keys.key.search 'r',
          rhs = function()
            require('spectre').open()
          end,
          desc = 'Replace in files (Spectre)',
        },
      },
    },
  },

  {
    src = util.gh 'folke/flash.nvim',
    enabled = nixInfo(false, 'settings', 'cats', 'rich_editor'),
    data = {
      event = 'VeryLazy',
      after = function()
        ---@type Flash.Config
        local opts = {}
        require('flash.nvim').setup(opts)
      end,
      keys = {
        {
          lhs = 's',
          rhs = function()
            require('flash').jump()
          end,
          mode = { 'n', 'x', 'o' },
          desc = 'Flash',
        },
        {
          lhs = 'S',
          rhs = function()
            require('flash').treesitter()
          end,
          mode = { 'n', 'x', 'o' },
          desc = 'Flash treesitter',
        },
        {
          lhs = 'r',
          rhs = function()
            require('flash').remote()
          end,
          mode = 'o',
          desc = 'Remote flash',
        },
        {
          lhs = 'R',
          rhs = function()
            require('flash').treesitter_search()
          end,
          desc = 'Treesitter search',
        },
        {
          lhs = '<C-s>',
          rhs = function()
            require('flash').toggle()
          end,
          mode = 'c',
          desc = 'Toggle flash search',
        },
      },
    },
  },

  {
    src = util.gh 'stevearc/oil.nvim',
    name = 'oil',
    data = {
      lazy = false,
      after = function()
        ---@module 'oil'
        ---@type oil.setupOpts
        local opts = {
          columns = { 'icon' },
          keymaps = {
            ['<C-h>'] = false,
            ['<C-l>'] = false,
            ['<C-n>'] = 'actions.select_split',
            ['<C-m>'] = 'actions.refresh',
          },
          view_options = {
            show_hidden = true,
            is_always_hidden = function(name)
              local always_hidden = {
                ['.git'] = true,
                ['.jj'] = true,
                ['.direnv'] = true,
                ['.DS_Store'] = true,
              }
              return always_hidden[name] ~= nil
            end,
          },
        }
        require('oil').setup(opts)
      end,
      keys = {
        {
          lhs = keys.key.find 'e',
          rhs = '<cmd>Oil<cr>',
          desc = 'Open Oil (parent dir)',
        },
        {
          lhs = keys.key.find 'E',
          rhs = '<cmd>Oil .<cr>',
          desc = 'Open Oil (cwd)',
        },
        {
          lhs = '<leader>e',
          rhs = keys.key.find 'e',
          desc = 'Open Oil (parent dir)',
          remap = true,
        },
        {
          lhs = '<leader>E',
          rhs = keys.key.find 'E',
          desc = 'Open Oil (cwd)',
          remap = true,
        },
      },
    },
  },

  {
    src = util.gh 'folke/persistence.nvim',
    name = 'persistence',
    data = {
      event = 'BufReadPre',
      after = function()
        require('persistence').setup {}
      end,
      keys = {
        {
          lhs = keys.key.session 's',
          rhs = function()
            require('persistence').load()
          end,
          desc = 'Restore session',
        },
        {
          lhs = keys.key.session 'l',
          rhs = function()
            require('persistence').load { last = true }
          end,
          desc = 'Restore last session',
        },
        {
          lhs = keys.key.session 'd',
          rhs = function()
            require('persistence').stop()
          end,
          desc = 'Do not save current session',
        },
        {
          lhs = keys.key.session 'p',
          rhs = function()
            require('persistence').select()
          end,
          desc = 'Select session to restore',
        },
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    src = util.gh 'NMAC427/guess-indent.nvim',
    name = 'guess-indent',
    data = {
      after = function()
        require('guess-indent').setup {}
      end,
      cmd = 'GuessIndent',
    },
  },

  {
    src = util.gh 'mbbill/undotree',
    name = 'undotree',
    data = {
      keys = {
        {
          lhs = keys.key.inspect 'u',
          rhs = '<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>',
          desc = 'Toggle Undotree',
        },
      },
    },
  },

  {
    'RRethy/vim-illuminate',
    enabled = nixCats 'rich_editor',
    event = 'BufReadPre',
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
      disable_keymaps = false,
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
    end,
    keys = {
      {
        keys.key.next ']',
        function()
          require('illuminate').goto_next_reference(false)
        end,
        desc = 'Go to next reference',
      },
      {
        keys.key.prev '[',
        function()
          require('illuminate').goto_prev_reference(false)
        end,
        desc = 'Go to previous reference',
      },
      {
        '[]',
        function()
          require('illuminate').textobj_select()
        end,
        desc = 'Select word for use as text-object',
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        changedelete = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        untracked = { text = '+' },
      },
      -- signs = {
      --   add = { text = '▎' },
      --   change = { text = '▎' },
      --   changedelete = { text = '▎' },
      --   delete = { text = '' },
      --   topdelete = { text = '' },
      --   untracked = { text = '▎' },
      -- },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function lmap(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        lmap('n', keys.key.next 'c', function()
          if vim.wo.diff then
            vim.cmd.normal { keys.key.next 'c', bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'next'
          end
        end, 'Go to next hunk')

        lmap('n', keys.key.prev 'c', function()
          if vim.wo.diff then
            vim.cmd.normal { keys.key.prev 'c', bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'prev'
          end
        end, 'Go to previous hunk')

        local gmap = function(mode, l, r, desc)
          vim.keymap.set(mode, keys.key.git(l), r, { buffer = bufnr, desc = desc })
        end

        -- Actions
        gmap('n', 's', gitsigns.stage_hunk, 'Stage hunk')
        gmap('n', 'r', gitsigns.reset_hunk, 'Reset hunk')

        gmap('v', 's', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage selected lines')

        gmap('v', 'r', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset selected lines')

        gmap('n', 'S', gitsigns.stage_buffer, 'Stage buffer')
        gmap('n', 'R', gitsigns.reset_buffer, 'Reset buffer')
        gmap('n', 'p', gitsigns.preview_hunk, 'Preview hunk')
        gmap('n', 'i', gitsigns.preview_hunk_inline, 'Preview hunk inline')

        gmap('n', 'b', function()
          gitsigns.blame_line { full = true }
        end, 'Blame current line')

        gmap('n', 'd', gitsigns.diffthis, 'Vimdiff file')

        gmap('n', 'D', function()
          ---@diagnostic disable-next-line: param-type-mismatch
          gitsigns.diffthis '~'
        end, 'Vimdiff file against previous commit')

        gmap('n', 'Q', function()
          ---@diagnostic disable-next-line: param-type-mismatch
          gitsigns.setqflist 'all'
        end, 'Open QuickFix list with all hunks in all files')
        gmap('n', 'q', gitsigns.setqflist, 'Open QuickFix list with all hunks in current buffer')

        -- Toggles
        gmap('n', 'lb', gitsigns.toggle_current_line_blame, 'Toggle current line blame virtual text')
        gmap('n', 'iw', gitsigns.toggle_word_diff, 'Highlight word diffs inline')

        -- Text object
        lmap({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select hunk under cursor')
      end,
    },
  },

  {
    'rachartier/tiny-inline-diagnostic.nvim',
    enabled = nixCats 'rich_editor',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config { virtual_text = false }
    end,
  },

  {
    'windwp/nvim-autopairs',
    dependencies = {
      {
        -- https://github.com/Saghen/blink.cmp/discussions/157
        'saghen/blink.cmp',
        opts = { completion = { accept = { auto_brackets = { enabled = true } } } },
      },
    },
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { 'markdown' },
    keys = {
      {
        keys.key.ui 'm',
        function()
          require('render-markdown').set_buf()
        end,
        desc = 'Toggle Markdown rendering',
      },
    },
  },
}
