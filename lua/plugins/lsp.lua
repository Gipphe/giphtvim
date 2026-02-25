return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    enabled = require('nixCatsUtils').enableForCategory 'lsp',

    -- lspconfig {{{
    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    -- NOTE: nixCats: there is help in nixCats for lsps at `:h nixCats.LSPs` and also `:h nixCats.luaUtils`
    --
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --
    -- Some languages (like typescript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    -- }}}
    opts = {
      category_servers = {
        elm = 'elmls',
        nix = { 'nil', require('nixCatsUtils').whenNixCatsElse('nixd', 'rnix') },
        powershell = 'powershell_es',
        bash = 'bashls',
        json = 'jsonls',
        html = 'html',
        js = { 'eslint', 'tailwindcss' },
        ts = { 'eslint', 'taildinwcss', 'ts_ls' },
        fish = 'fish_lsp',
        terraform = 'terraformls',
        yaml = 'yamlls',
        markdown = 'marksman',
        python = 'ruff',
        lua = 'lua_ls',
        docker = 'dockerls',
        qml = 'qmlls',
        xml = 'lemminx',
        go = 'gopls',
        sql = 'sqls',
        rust = 'rust_analyzer',
      },
    },
    dependencies = {
      {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        'williamboman/mason.nvim',
        -- NOTE: nixCats: only enable mason if nix wasn't involved.
        -- because we will be using nix to download things instead.
        enabled = not require('nixCatsUtils').isNixCats,
        opts = {},
      }, -- NOTE: Must be loaded before dependants

      {
        'williamboman/mason-lspconfig.nvim',
        -- NOTE: nixCats: only enable mason if nix wasn't involved.
        -- because we will be using nix to download things instead.
        enabled = not require('nixCatsUtils').isNixCats,
      },

      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        -- NOTE: nixCats: only enable mason if nix wasn't involved.
        -- because we will be using nix to download things instead.
        enabled = not require('nixCatsUtils').isNixCats,
      },
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        ---@type table See |fidget-options| or |fidget-option.txt|.
        opts = {},
      },
      'folke/lazydev.nvim',
      'saghen/blink.cmp',
    },

    config = function(_, opts)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          ---@param keys string
          ---@param func string|function
          ---@param desc string
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          -- Open LSP info
          map('<leader>cl', '<cmd>LspInfo<cr>', 'Lsp info')
          map('<leader>cL', '<cmd>LspLog<cr>', 'Lsp log')

          -- Jump to the definition of the word under your cursor.
          -- This is where a variable was first declared, or where a function is defined, etc.
          -- To jump back, press <C-t>.
          map('gd', function()
            require('snacks').picker.lsp_definitions { reuse_win = true }
          end, 'Goto definition')

          map('gr', function()
            require('snacks').picker.lsp_references()
          end, 'Goto references')

          map('gD', function()
            vim.lsp.buf.declaration()
          end, 'Goto declaration')

          map('gI', function()
            require('snacks').picker.lsp_implementations { reuse_win = true }
          end, 'Goto implementation')

          map('gy', function()
            require('snacks').picker.lsp_type_definitions { reuse_win = true }
          end, 'Goto type definition')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', function()
            vim.lsp.buf.hover { border = 'rounded' }
          end, 'Hover documentation')

          map('gK', function()
            vim.lsp.buf.signature_help { border = 'rounded' }
          end, 'Signature help')

          vim.keymap.set('i', '<C-k>', function()
            vim.lsp.buf.signature_help { border = 'rounded' }
          end, { desc = 'Signature help', buffer = event.buf })

          vim.keymap.set({ 'n', 'v' }, '<leader>ca', function()
            vim.lsp.buf.code_action { border = 'rounded' }
          end, { desc = 'Code action', buffer = event.buf })

          vim.keymap.set({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, { desc = 'Run codelens', buffer = event.buf })
          vim.keymap.set('n', '<leader>cC', vim.lsp.codelens.refresh, { desc = 'Refresh & display codelens', buffer = event.buf })
          vim.keymap.set('n', '<leader>cA', function()
            vim.lsp.buf.code_action {
              context = {
                only = { 'source' },
                diagnostics = {},
              },
              border = 'rounded',
            }
          end, { desc = 'Source action', buffer = event.buf })

          vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = event.buf })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- vim.keymap.set('n', '<leader>cy', require('snacks').picker.lsp_document_symbols, { desc = 'Document symbols', buffer = event.buf })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- vim.keymap.set('n', '<leader>cY', require('snacks').picker.lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols', buffer = event.buf })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', function()
            vim.lsp.buf.declaration { border = 'rounded' }
          end, 'Goto declaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>cth', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, 'Toggle inlay hints')
          end
        end,
      })

      local severity = vim.diagnostic.severity
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [severity.ERROR] = '󰅚 ',
            [severity.WARN] = '󰀪 ',
            [severity.INFO] = '󰋽 ',
            [severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [severity.ERROR] = diagnostic.message,
              [severity.WARN] = diagnostic.message,
              [severity.INFO] = diagnostic.message,
              [severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })
      ---@type string[]
      local servers = opts.servers or {}

      -- Append servers based on categories
      for cat, srvs in pairs(opts.category_servers) do
        if nixCats(cat) then
          local srvs_list = srvs
          if type(srvs) == 'function' then
            srvs_list = srvs()
          elseif type(srvs) ~= 'table' then
            srvs_list = { srvs }
          end
          for _, srv in pairs(srvs_list) do
            servers[#servers + 1] = srv
          end
        end
      end
      servers = vim.fn.uniq(vim.fn.sort(servers)) --[[@as string[] ]]

      -- NOTE: nixCats: if nix, use vim.lsp instead of mason
      -- You could MAKE it work, using lspsAndRuntimeDeps and sharedLibraries in nixCats
      -- but don't... its not worth it. Just add the lsp to lspsAndRuntimeDeps.
      if require('nixCatsUtils').isNixCats then
        vim.lsp.enable(servers)
      else
        -- NOTE: nixCats: and if no nix, do it the normal way

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require('mason').setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        require('mason-tool-installer').setup { ensure_installed = servers }

        require('mason-lspconfig').setup {
          ensure_installed = {},
          automatic_enable = true,
        }
      end
    end,
  },

  -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  {
    'folke/lazydev.nvim',
    enabled = nixCats 'lsp' and nixCats 'lua',
    dependencies = {
      {
        'saghen/blink.cmp',
        opts = {
          sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
              lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
              },
            },
          },
        },
      },
    },
    ft = 'lua',
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        -- adds type hints for nixCats global
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'mrcjkb/haskell-tools.nvim',
    enabled = nixCats 'lsp' and nixCats 'haskell',
    version = '^6',
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('haskell-tools', { clear = true }),
        pattern = { 'haskell' },
        callback = function(buffer)
          local ht = require 'haskell-tools'
          local lmap = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, {
              noremap = true,
              silent = true,
              buffer = buffer.buf,
              desc = desc,
            })
          end
          lmap('n', '<leader>cl', vim.lsp.codelens.run, 'Run codelens')
          lmap('n', '<leader>chs', ht.hoogle.hoogle_signature, 'Hoogle search type signature under cursor')
          lmap('n', '<leader>cea', ht.lsp.buf_eval_all, 'Evaluate all code snippets')
          lmap('n', '<leader>cpr', ht.repl.toggle, 'Toggle GHCi repl for the current package')
          lmap('n', '<leader>cpR', function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end, 'Toggle GHCi repl for current buffer')
          lmap('n', '<leader>cpq', ht.repl.quit, 'Close GHCi repl')
        end,
      })
    end,
    ft = { 'haskell' },
  },

  {
    'jmbuhr/otter.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'lsp',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      handle_leading_whitespace = true,
    },
  },

  {
    'elkowar/yuck.vim',
    enabled = nixCats 'yuck',
    ft = { 'yuck' },
  },

  {
    'lukahartwig/pnpm.nvim',
    enabled = nixCats 'js' or nixCats 'ts',
    ft = { 'js', 'ts', 'tsx', 'jsx' },
  },

  {
    'fatih/vim-go',
    enabled = nixCats 'go',
    ft = { 'go', 'html', 'gotmpl', 'gohtmltmpl' },
    config = function()
      vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufWinEnter', 'BufWritePre' }, {
        group = vim.api.nvim_create_augroup('gotmpl_syntax', { clear = true }),
        pattern = '*.gohtml,*.gotmpl,*.html',
        callback = function(event)
          if vim.fn.search('{{.\\+}}', 'nw') ~= 0 then
            vim.api.nvim_set_option_value('filetype', 'gohtmltmpl', { buf = event.buf })
          end
        end,
      })
    end,
  },
}
