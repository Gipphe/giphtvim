local util = require 'util'

return {
  {
    src = util.gh 'nvim-treesitter/nvim-treesitter',
    name = 'nvim-treesitter',
    version = 'main',
    data = {
      lazy = false,
      before = function()
        util.pack.onInstallOrUpdate('nvim-treesitter', function()
          vim.cmd [[:TSUpdate]]
        end)
      end,
      after = function()
        local opts = {
          install_dir = vim.fn.stdpath 'data' .. '/site',
        }
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
  },

  {
    src = util.gh 'andymass/vim-matchup',
    name = 'matchup',
    data = {
      event = 'BufReadPre',
      after = function()
        local opts = {
          treesitter = {
            stopline = 500,
          },
          matchparen = {
            offscreen = {
              method = 'popup',
            },
          },
        }
        require('match-up').setup(opts)
      end,
    },
  },

  {
    src = util.gh 'windwp/nvim-ts-autotag',
    name = 'ts-autotag',
    data = {
      lazy = false,
      after = function()
        require('nvim-ts-autotag').setup {}
      end,
    },
  },

  {
    src = util.gh 'JoosepAlviste/nvim-ts-context-commentstring',
    name = 'nvim-ts-context-commentstring',
    data = {
      after = function()
        vim.g.skip_ts_context_commentstring_module = true
        local opts = {
          enable_autocmd = false,
        }
        require('ts_context_commentstring').setup(opts)
      end,
    },
  },

  {
    src = util.gh 'nvim-treesitter/nvim-treesitter-context',
    name = 'nvim-treesitter-context',
    data = {
      after = function()
        local opts = {
          mode = 'cursor',
          max_lines = 3,
        }
        require('treesitter-context').setup(opts)
      end,
    },
  },

  {
    src = util.gh 'MeanderingProgrammer/treesitter-modules.nvim',
    name = 'treesitter-modules',
    data = {
      after = function()
        ---@module 'treesitter-modules'
        ---@type ts.mod.UserConfig
        local opts = {
          -- TODO: Uncomment these lines once the nixpkgs-provided grammars work
          -- correctly.
          --
          -- ensure_installed = require('nixCatsUtils').whenNotNixCatsElse { 'stable' },
          -- auto_install = not require('nixCatsUtils').isNixCats,
          ensure_installed = { 'stable' },
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
        }
        require('treesitter-modules').setup(opts)
      end,
    },
  },
}
