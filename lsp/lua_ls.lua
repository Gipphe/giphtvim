return {
  enabled = nixInfo(false, 'settings', 'cats', 'lua'),
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = {
        globals = { 'nixInfo' },
        disable = { 'missing-fields' },
      },
    },
  },
}
