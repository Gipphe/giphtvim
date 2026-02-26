return {
  enabled = nixCats 'nix',
  settings = {
    nixpkgs = {
      expr = nixCats.extra 'nixd.nixpkgs' or 'import <nixpkgs> { }',
    },
    formatting = {
      command = { 'nixfmt' },
    },
    options = nixCats.extra 'nixd.options' or {},
  },
}
