local util = require 'util'

return {
  {
    'andymass/vim-matchup',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    event = 'BufReadPre',
    opts = {
      treesitter = {
        stopline = 500,
      },
      matchparen = {
        offscreen = {
          method = 'popup',
        },
      },
    },
  },

  {
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {},
    lazy = false,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      enable_autocmd = false,
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      mode = 'cursor',
      max_lines = 3,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- TODO: re-enable once it's no longer broken on nixpkgs
    enabled = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
          [']a'] = '@parameter.inner',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
          [']A'] = '@parameter.inner',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
          ['[a'] = '@parameter.inner',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[C'] = '@class.outer',
          ['[A'] = '@parameter.inner',
        },
      },
    },
  },
  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      -- TODO: Uncomment these lines once the nixpkgs-provided grammars work
      -- correctly.
      --
      -- ensure_installed = require('nixCatsUtils').whenNotNixCatsElse { 'stable' },
      -- auto_install = not require('nixCatsUtils').isNixCats,
      -- ensure_installed = {'stable'},
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      fold = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    -- dependencies = {
    --   -- TODO: Find replacement for nvim-treesitter main branch
    --   -- 'nvim-treesitter/nvim-treesitter-refactor',
    -- },
    branch = 'main',
    lazy = false,
    build = require('nixCatsUtils').lazyAdd ':TSUpdate',
    opts = {
      -- TODO: Find replacement compatible with nvim-treesitter main branch
      -- Do I even need this? I use LSP for the `navigation` stuff,
      -- and smart renaming could probably be handled by the LSP as
      -- well.
      --
      -- refactor = {
      --   highlight_current_scope = {
      --     -- Basically highlight huge swaths of code all the time.
      --     enable = false,
      --   },
      --   highlight_definitions = {
      --     enable = true,
      --     clear_on_cursor_move = false,
      --   },
      --   navigation = {
      --     enable = true,
      --     keymaps = {
      --       goto_definition = 'gd',
      --       list_definitions = 'gD',
      --       goto_next_usage = '<a-*>',
      --       goto_previous_usage = '<a-#>',
      --     },
      --   },
      --   smart_rename = {
      --     enable = true,
      --     keymaps = {
      --       smart_rename = '<leader>cr',
      --     },
      --   },
      -- },
    },
    keys = {
      -- TODO: Find nvim-treesitter main branch equivalent
      -- { '<leader>ut', '<cmd>TSContextToggle<cr>', desc = 'Toggle Treesitter context' },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      -- NOTE: We use the `main` branch of nvim-treesitter, and thus have to take
      -- care with which options we use when following published guides and
      -- snippets.

      -- Prefer git instead of curl in order to improve connectivity in some environments
      -- TODO: Port to nvim-treesitter main branch implementation. See if there
      -- is an option for this.
      -- require('nvim-treesitter.install').prefer_git = not util.is_windows()

      require('nvim-treesitter').setup(opts)

      local hl_group = vim.api.nvim_create_augroup('highlight_nbsp', { clear = true })
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = hl_group,
        command = 'highlight BreakSpaceChar ctermbg=red guibg=#f92672',
      })
      vim.api.nvim_create_autocmd('BufWinEnter', {
        group = hl_group,
        -- This space character is a unicode NBSP character. You can get one by
        -- pressing AltGr+Space on Linux. Code usually doesn't like it though.
        command = "call matchadd('BreakSpaceChar', ' ')",
      })
    end,
  },
}
