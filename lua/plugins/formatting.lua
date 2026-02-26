local keys = require 'keygroups'
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      keys.key.code 'f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
    {
      keys.key.code 'F',
      function()
        require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
      end,
      mode = { 'n', 'v' },
      desc = 'Format injected langs',
    },
  },
  opts = function(opts)
    opts = opts or {}
    local category_formatters = {
      markdown = {
        ['markdown.mdx'] = prettier,
        markdown = prettier,
      },
      fish = {
        fish = { 'fish_indent' },
      },
      haskell = {
        haskell = { 'fourmolu', stop_after_first = true },
        cabal = { 'cabal_fmt' },
      },
      html = {
        css = prettier,
        html = prettier,
      },
      js = {
        javascript = prettier,
        javascriptreact = prettier,
      },
      ts = {
        typescript = prettier,
        typescriptreact = prettier,
      },
      json = {
        json = prettier,
        jsonc = prettier,
      },
      lua = {
        lua = { 'stylua' },
      },
      nix = {
        nix = { 'nixfmt' },
      },
      python = {
        python = { 'ruff_format', 'ruff_organize_imports' },
      },
      bash = {
        sh = { 'shfmt' },
      },
      terraform = {
        terraform = { 'tofu_fmt' },
      },
      yaml = {
        yaml = prettier,
      },
    }
    local settings = {
      notify_on_error = true,
      notify_no_formatters = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        ['*'] = { 'codespell' },
        ['_'] = { 'trim_whitespace' },
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
      },
    }

    for cat, formatters in pairs(category_formatters) do
      if nixCats(cat) then
        settings.formatters_by_ft = vim.tbl_deep_extend('force', {}, settings.formatters_by_ft, formatters)
      end
    end

    return vim.tbl_deep_extend('force', {}, opts, settings)
  end,
}
