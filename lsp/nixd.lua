local options_from_nix = nixCats.extra 'nixd.options' or {}

return {
  enabled = nixCats 'nix',
  settings = {
    nixpkgs = {
      expr = nixCats.extra 'nixd.nixpkgs' or 'import <nixpkgs> { }',
    },
    formatting = {
      command = { 'nixfmt' },
    },
    options = options_from_nix,
  },
}
