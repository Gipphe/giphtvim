return {
  enabled = nixInfo(false, 'settings', 'cats', 'yaml'),
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
}
