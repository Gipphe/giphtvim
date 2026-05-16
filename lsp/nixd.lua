return {
  enabled = nixInfo(false, 'settings', 'cats', 'nix'),
  settings = {
    nixpkgs = {
      expr = nixInfo('import <nixpkgs> {}', 'settings', 'nixd', 'nixpkgs', 'expr'),
    },
    formatting = {
      command = { 'nixfmt' },
    },
    options = nixInfo({}, 'settings', 'nixd', 'options'),
  },
}
