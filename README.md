# This is my Neovim config

> There are many like it, but this one is (mostly) mine.

This Neovim config intended to be compatible with both `nix` and
`vim.pack.add`/`mason` for fetching plugins and dependencies.

It uses [nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules)
to provide a wrapped module that can be included in NixOS or home-manager, or
configured as used as a standalone package as-is.
