local keys = require 'keygroups'
local catUtils = require 'nixCatsUtils'
return {
  {
    'nvim-pack/nvim-spectre',
    enabled = catUtils.cat('rich_editor', false),
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'folke/trouble.nvim',
    },
    -- TODO: Figure out whether I need this. Keys conflict with bundled Telescope bindings.
    enable = false,
    opts = {},
    keys = {
      {
        keys.key.search 'r',
        function()
          require('spectre').open()
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },

  {
    'folke/flash.nvim',
    enabled = catUtils.cat('rich_editor', false),
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        's',
        function()
          require('flash').jump()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Flash',
      },
      {
        'S',
        function()
          require('flash').treesitter()
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Flash treesitter',
      },
      {
        'r',
        function()
          require('flash').remote()
        end,
        mode = 'o',
        desc = 'Remote flash',
      },
      {
        'R',
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter search',
      },
      {
        '<C-s>',
        function()
          require('flash').toggle()
        end,
        mode = 'c',
        desc = 'Toggle flash search',
      },
    },
  },

  {
    'linux-cultist/venv-selector.nvim',
    enabled = catUtils.cat('rich_editor', false),
    dependencies = {
      'neovim/nvim-lspconfig',
      'folke/snacks.nvim',
    },
    ft = 'python',
    ---@module 'venv-selector'
    ---@type venv-selector.Options
    opts = {
      search = {},
      options = {},
    },
    keys = {
      { keys.key.code 'v', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv' },
    },
  },

  {
    'aca/marp.nvim',
    enabled = catUtils.cat('rich_editor', false),
    main = 'marp.nvim',
    version = false,
    dependencies = {
      {
        'folke/which-key.nvim',
        opts = require('util').concat_opts {
          { '<leader>m', group = '+marp' },
        },
      },
    },
    keys = {
      {
        '<leader>mo',
        function()
          require('marp.nvim').ServerStart()
        end,
        desc = 'Start Marp server',
      },
      {
        '<leader>mc',
        function()
          require('marp.nvim').ServerStop()
        end,
        desc = 'Stop Marp server',
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('VimLeavePre', {
        group = vim.api.nvim_create_augroup('marp', { clear = true }),
        callback = function()
          require('marp.nvim').ServerStop()
        end,
      })
    end,
  },

  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    ---@module 'oil'
    ---@type oil.setupOpts
    opts = {
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
    },
    keys = {
      { keys.key.find 'e', '<cmd>Oil<cr>', desc = 'Open Oil (parent dir)' },
      { keys.key.find 'E', '<cmd>Oil .<cr>', desc = 'Open Oil (cwd)' },
      { '<leader>e', keys.key.find 'e', desc = 'Open Oil (parent dir)', remap = true },
      { '<leader>E', keys.key.find 'E', desc = 'Open Oil (cwd)', remap = true },
    },
  },

  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      {
        keys.key.session 's',
        function()
          require('persistence').load()
        end,
        desc = 'Restore session',
      },
      {
        keys.key.session 'l',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore last session',
      },
      {
        keys.key.session 'd',
        function()
          require('persistence').stop()
        end,
        desc = 'Do not save current session',
      },
      {
        keys.key.session 'p',
        function()
          require('persistence').select()
        end,
        desc = 'Select session to restore',
      },
    },
  },

  -- Detect tabstop and shiftwidth automatically
  {
    'NMAC427/guess-indent.nvim',
    opts = {},
  },

  {
    'folke/trouble.nvim',
    enabled = nixCats 'rich_editor',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Trouble',
    opts = {},
    keys = {
      { keys.key.diagnostic 'x', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { keys.key.diagnostic 'X', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { keys.key.diagnostic 'L', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { keys.key.diagnostic 'Q', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      { keys.key.code 's', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { keys.key.code 'x', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },

      -- { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      -- { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      -- { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      -- { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },

      {
        keys.key.prev 'q',
        function()
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
        keys.key.next 'q',
        function()
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

  {
    'mbbill/undotree',
    keys = {
      { keys.key.inspect 'u', '<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>', desc = 'Toggle Undotree' },
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
    'nvim-tree/nvim-web-devicons',
    opts = {},
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
}
