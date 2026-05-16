inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs) self;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}.vimPlugins)
    pnpm-nvim
    nvim-highlight-colors
    ;
in
{
  imports = [ wlib.wrapperModules.neovim ];
  # NOTE: see the tips and tricks section or the bottom of this file + flake inputs to understand this value
  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    # Makes plugins autobuilt from our inputs available with
    # `config.nvim-lib.neovimPlugins.<name_without_prefix>`
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  # choose a directory for your config.
  config.settings.config_directory = ./.;

  config.hosts = {
    python3.nvim-host.enable = true;
    node.nvim-host.enable = true;
  };

  # If the defaults are fine, you can just provide the `.data` field
  # In this case, a list of specs, instead of a single plugin like above
  config.specs.lze = [
    # if defaults is fine, you can just provide the `.data` field
    {
      data = config.nvim-lib.neovimPlugins.lze;
      lazy = false;
    }
    # but these can be specs too!
    {
      # these ones can't take lists though
      data = config.nvim-lib.neovimPlugins.lzextras;
      lazy = false;
      # things can target any spec that has a name.
      name = "lzextras";
      # now something else can be after = [ "lzextras" ]
      # the spec name is not the plugin name.
      # to override the plugin name, use `pname`
      # You could run something before your main init.lua like this
      # before = [ "INIT_MAIN" ];
      # You can include configuration and translated nix values here as well!
      # type = "lua"; # | "fnl" | "vim"
      # info = { };
      # config = ''
      #   local info, pname, lazy = ...
      # '';
    }
  ];

  config.specs.general = {
    data =
      builtins.attrValues {
        inherit (pkgs.vimPlugins)
          blink-cmp
          bufferline-nvim
          conform-nvim
          gitsigns-nvim
          guess-indent-nvim
          luasnip
          mini-ai
          mini-bufremove
          mini-comment
          mini-indentscope
          mini-statusline
          mini-surround
          nvim-autopairs
          nvim-treesitter
          nvim-treesitter-context
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          oil-nvim
          persistence-nvim
          plenary-nvim
          promise-async
          snacks-nvim
          treesitter-modules-nvim
          undotree
          vim-css-color
          vim-matchup
          which-key-nvim
          wilder-nvim
          zellij-nav-nvim
          ;
      }
      ++ [ nvim-highlight-colors ];

    runtimePkgs =
      builtins.attrValues {
        inherit (pkgs)
          codespell
          fd
          gcc # Required by tree-sitter
          gzip # Required by tree-sitter
          ripgrep
          tree-sitter
          universal-ctags
          ;
      }
      ++ [
        pkgs.haskellPackages.cabal-fmt
        pkgs.stdenv.cc.cc
        self.packages.${pkgs.stdenv.hostPlatform.system}.prettier-with-plugins
      ];
  };
  config.specs.catppuccin = {
    data = [ pkgs.vimPlugins.catppuccin-nvim ];
    lazy = true;
  };

  config.specs.bash = {
    data = null;
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        bash-language-server
        shfmt
        ;
    };
  };
  config.specs.docker = {
    data = null;
    runtimePkgs = [ pkgs.dockerfile-language-server ];
  };
  config.specs.fish = {
    data = null;
    runtimePkgs = [ pkgs.fish-lsp ];
  };
  config.specs.go = {
    data = [ pkgs.vimPlugins.vim-go ];
    runtimePkgs = [ pkgs.gopls ];
  };
  config.specs.rich_ui = {
    data = [ pkgs.vimPlugins.todo-comments-nvim ];
  };
  config.specs.rich_editor = {
    data = builtins.attrValues {
      inherit (pkgs.vimPlugins)
        flash-nvim
        nvim-spectre
        tiny-inline-diagnostic-nvim
        trouble-nvim
        venv-selector-nvim
        vim-illuminate
        ;
    };
  };
  config.specs.xml = {
    data = null;
    runtimePkgs = [ pkgs.lemminx ];
  };
  config.specs.lua = {
    data = [ pkgs.vimPlugins.lazydev-nvim ];
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        lua-language-server
        stylua
        ;
    };
  };
  config.specs.markdown = {
    data = [ pkgs.vimPlugins.render-markdown-nvim ];
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        markdownlint-cli
        marksman
        ;
    };
  };
  config.specs.terraform = {
    data = null;
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        opentofu
        tofu-ls
        terraform-ls
        ;
    };
  };
  config.specs.powershell = {
    data = null;
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        powershell
        powershell-editor-services
        ;
    };
  };
  config.info.powershell_es = lib.mkIf config.specs.powershell.enable "${pkgs.powershell-editor-services
  }";
  config.specs.python = {
    data = null;
    runtimePkgs = [ pkgs.ruff ];
  };
  config.specs.rust = {
    data = null;
    runtimePkgs = [ pkgs.rust-analyzer ];
  };
  config.specs.sql = {
    data = null;
    runtimePkgs = [ pkgs.sqls ];
  };
  config.specs.js = {
    data = [ pnpm-nvim ];
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        deno
        vscode-langservers-extracted
        tailwindcss-language-server
        ;
    };
  };
  config.specs.ts = {
    data = [ pnpm-nvim ];
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        deno
        vscode-langservers-extracted
        tailwindcss-language-server
        typescript-language-server
        ;
    };
  };
  config.specs.html = {
    data = null;
    runtimePkgs = [ pkgs.vscode-langservers-extracted ];
  };
  config.specs.json = {
    data = null;
    runtimePkgs = [ pkgs.vscode-langservers-extracted ];
  };
  config.specs.yaml = {
    data = null;
    runtimePkgs = [ pkgs.yaml-language-server ];
  };
  config.specs.nix = {
    data = null;
    runtimePkgs = builtins.attrValues {
      inherit (pkgs)
        nil
        nix-doc
        nixd
        nixfmt
        ;
    };
  };
  config.specs.yuck = {
    data = [ pkgs.vimPlugins.yuck-vim ];
    runtimePkgs = [ pkgs.kdePackages.qtdeclarative ];
  };
  config.specs.elm = {
    data = null;
    runtimePkgs = [ pkgs.elmPackages.elm-language-server ];
  };
  config.specs.haskell = {
    data = [ pkgs.vimPlugins.haskell-tools-nvim ];
    runtimePkgs = builtins.attrValues {
      inherit (pkgs.haskellPackages)
        fast-tags
        fourmolu
        haskell-language-server
        hoogle
        ;
    };
  };
  config.specs.lsp.data = builtins.attrValues {
    inherit (pkgs.vimPlugins)
      fidget-nvim
      nvim-lspconfig
      otter-nvim
      ;
  };

  # These are from the tips and tricks section of the neovim wrapper docs!
  # https://birdeehub.github.io/nix-wrapper-modules/neovim.html#tips-and-tricks
  # We could put these in another module and import them here instead!

  # This submodule modifies both levels of your specs
  config.specMods =
    {
      # When this module is ran in an inner list,
      # this will contain `config` of the parent spec
      # parentSpec ? null,
      # and this will contain `options`
      # otherwise they will be `null`
      # parentOpts ? null,
      # parentName ? null,
      # and then config from this one, as normal
      # config,
      # and the other module arguments.
      ...
    }:
    {
      # you could use this to change defaults for the specs
      # config.collateGrammars = lib.mkDefault (parentSpec.collateGrammars or false);
      # config.autoconfig = lib.mkDefault (parentSpec.autoconfig or false);
      # config.runtimeDeps = lib.mkDefault (parentSpec.runtimeDeps or false);
      # config.pluginDeps = lib.mkDefault (parentSpec.pluginDeps or false);
      # or something more interesting like:
      # add an runtimePkgs field to the specs themselves
      options.runtimePkgs = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
        description = "a runtimePkgs spec field to put packages to suffix to the PATH";
      };
      # You could do this too
      # config.before = lib.mkDefault [ "INIT_MAIN" ];
      config.lazy = lib.mkDefault true;
    };
  config.runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];

  # Inform our lua of which top level specs are enabled
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };
  # build plugins from inputs set
  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    default =
      prefix: inputs:
      lib.pipe inputs [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (
          input:
          let
            name = lib.removePrefix prefix input;
          in
          {
            inherit name;
            value = config.nvim-lib.mkPlugin name inputs.${input};
          }
        ))
        builtins.listToAttrs
      ];
  };
}
