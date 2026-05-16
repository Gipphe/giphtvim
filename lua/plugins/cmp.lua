local util = require 'util'

return {
  {
    'luasnip',
    pack = {
      src = util.gh 'L3MON4D3/LuaSnip',
    },
    on_require = { 'luasnip' },
    before = function()
      if nixInfo.isNix then
        return
      end

      util.pack.onInstallOrUpdate('luasnip', function(ev)
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        vim.notify('Building luasnip', vim.log.levels.INFO)
        local obj = vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
        if obj.code == 0 then
          vim.notify('Building luasnip done', vim.log.levels.INFO)
        else
          vim.notify('Building luasnip failed', vim.log.levels.ERROR)
        end
      end)
    end,
    after = function()
      local opts = {
        keep_roots = true,
        link_roots = true,
        link_children = true,
        exit_roots = false,
        delete_check_events = 'TextChanged',
      }
      require('luasnip').setup(opts)
    end,
    keys = {
      {
        lhs = '<tab>',
        rhs = function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
        end,
        mode = 'i',
        expr = true,
        silent = true,
      },
      {
        lhs = '<tab>',
        rhs = function()
          return require('luasnip').jump(1)
        end,
        mode = 's',
      },
      {
        lhs = '<S-tab>',
        rhs = function()
          return require('luasnip').jump(-1)
        end,
        mode = 's',
      },
    },
  },
  {
    'blink.cmp',
    pack = {
      src = util.gh 'saghen/blink.cmp',
      version = vim.version.range '^1.0',
    },
    event = 'VimEnter',
    on_require = { 'blink.cmp' },
    before = function()
      if nixInfo.isNix then
        return
      end

      util.pack.onInstallOrUpdate('blink.cmp', function(ev)
        vim.notify('Building blink.cmp', vim.log.levels.INFO)
        local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
        if obj.code == 0 then
          vim.notify('Building blink.cmp done', vim.log.levels.INFO)
        else
          vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
        end
      end)
    end,
    after = function()
      --- @module 'blink.cmp'
      --- @type blink.cmp.Config
      local opts = {
        keymap = {
          -- 'default' (recommended) for mappings similar to built-in completions
          --   <c-y> to accept ([y]es) the completion.
          --    This will auto-import if your LSP supports it.
          --    This will expand snippets if the LSP sent a snippet.
          -- 'super-tab' for tab to accept
          -- 'enter' for enter to accept
          -- 'none' for no mappings
          --
          -- For an understanding of why the 'default' preset is recommended,
          -- you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          --
          -- All presets have the following mappings:
          -- <tab>/<s-tab>: move to right/left of your snippet expansion
          -- <c-space>: Open menu or open docs if already open
          -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
          -- <c-e>: Hide menu
          -- <c-k>: Toggle signature help
          --
          -- See :h blink-cmp-config-keymap for defining your own keymap
          preset = 'super-tab',

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },
        completion = {
          -- By default, you may press `<c-space>` to show the documentation.
          -- Optionally, set `auto_show = true` to show the documentation after a delay.
          documentation = { auto_show = false, auto_show_delay_ms = 500 },

          list = {
            selection = {
              preselect = function(_)
                return not require('blink.cmp').snippet_active { direction = 1 }
              end,
            },
          },

          accept = {
            auto_brackets = {
              -- Required for windwp/nvim-autopairs
              -- https://github.com/Saghen/blink.cmp/discussions/157
              enabled = true,
            },
          },

          -- Requires for nvim-highlight-colors
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
        -- Conditionally add source configs for lazydev
        sources = {
          default = (function()
            if nixInfo(false, 'settings', 'cats', 'lsp') and nixInfo(false, 'settings', 'cats', 'lua') then
              return { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' }
            else
              return { 'lsp', 'path', 'snippets', 'buffer' }
            end
          end)(),
          providers = (function()
            local base = {
              lsp = { fallbacks = {} },
            }
            if nixInfo(false, 'settings', 'cats', 'lsp') and nixInfo(false, 'settings', 'cats', 'lua') then
              return vim.tbl_deep_extend('force', {}, base, {
                lazydev = {
                  name = 'LazyDev',
                  module = 'lazydev.integrations.blink',
                  -- make lazydev completions top priority (see `:h blink.cmp`)
                  score_offset = 100,
                },
              })
            end
            return base
          end)(),
        },
        snippets = { preset = 'luasnip' },
        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        -- See :h blink-cmp-config-fuzzy for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
      }
      require('blink.cmp').setup(opts)
    end,
  },
}
