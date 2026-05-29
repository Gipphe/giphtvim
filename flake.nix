{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };
    plugins-blink-cmp = {
      url = "github:saghen/blink.cmp";
      flake = false;
    };
    plugins-bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };
    plugins-conform-nvim = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    plugins-gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    plugins-guess-indent-nvim = {
      url = "github:NMAC427/guess-indent.nvim";
      flake = false;
    };
    plugins-luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    plugins-mini-ai = {
      url = "github:nvim-mini/mini.ai";
      flake = false;
    };
    plugins-mini-bufremove = {
      url = "github:nvim-mini/mini.bufremove";
      flake = false;
    };
    plugins-mini-comment = {
      url = "github:nvim-mini/mini.comment";
      flake = false;
    };
    plugins-mini-indentscope = {
      url = "github:nvim-mini/mini.indentscope";
      flake = false;
    };
    plugins-mini-statusline = {
      url = "github:nvim-mini/mini.statusline";
      flake = false;
    };
    plugins-mini-surround = {
      url = "github:nvim-mini/mini.surround";
      flake = false;
    };
    plugins-nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    plugins-nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    plugins-nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    plugins-nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };
    plugins-nvim-ts-context-commentstring = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    plugins-nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    plugins-oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
    plugins-persistence-nvim = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    plugins-plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    plugins-promise-async = {
      url = "github:kevinhwang91/promise-async";
      flake = false;
    };
    plugins-snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    plugins-treesitter-modules-nvim = {
      url = "github:MeanderingProgrammer/treesitter-modules.nvim";
      flake = false;
    };
    plugins-undotree = {
      url = "github:mbbill/undotree";
      flake = false;
    };
    plugins-vim-css-color = {
      url = "github:ap/vim-css-color";
      flake = false;
    };
    plugins-vim-matchup = {
      url = "github:andymass/vim-matchup";
      flake = false;
    };
    plugins-which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    plugins-wilder-nvim = {
      url = "github:gelguy/wilder.nvim";
      flake = false;
    };
    plugins-zellij-nav-nvim = {
      url = "github:swaits/zellij-nav.nvim";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs nixpkgs.lib.platforms.all;
      module = lib.modules.importApply ./module.nix inputs;
      neovimModule = {
        imports = [ module ];
        cats = baseCats;
        # specs = lib.mapAttrs (_: enabled: { inherit enabled; }) baseCats;
      };
      droidModule = {
        imports = [ module ];
        cats = droidCats;
      };
      neovimWrapper = wrappers.lib.evalModule neovimModule;
      droidWrapper = wrappers.lib.evalModule droidModule;
      baseCats = {
        lsp = true;
        rich_ui = true;
        rich_editor = true;
        narrow_screen = false;

        bash = true;
        docker = false;
        elm = false;
        fish = true;
        go = false;
        haskell = true;
        html = true;
        js = true;
        lua = true;
        markdown = true;
        nix = true;
        powershell = true;
        python = true;
        qml = false;
        rust = true;
        sql = true;
        terraform = true;
        ts = true;
        xml = false;
        yaml = true;
        yuck = true;
      };
      droidCats = baseCats // {
        lsp = false;
        rich_ui = false;
        rich_editor = false;
        narrow_screen = true;

        bash = false;
        docker = false;
        elm = false;
        fish = false;
        go = false;
        haskell = false;
        html = false;
        js = false;
        lua = false;
        markdown = true;
        nix = false;
        powershell = false;
        python = false;
        qml = false;
        rust = false;
        sql = false;
        terraform = false;
        ts = false;
        xml = false;
        yaml = true;
        yuck = false;
      };
    in
    {
      wrapperModules = {
        neovim = neovimWrapper;
        droid = droidWrapper;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = neovimWrapper.config;
        droid = droidWrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
        droid = final: prev: { neovim = self.wrappers.droid.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      legacyPackages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          vimPlugins = {
            marp-nvim = pkgs.vimUtils.buildVimPlugin {
              pname = "marp-nvim";
              version = "2025-04-02";
              src = pkgs.fetchFromGitHub {
                owner = "aca";
                repo = "marp.nvim";
                rev = "58d9544d0fa2d78b538e2e2a9b4c018228af0bfe";
                hash = "sha256-aVQsE3aQRH0t7FRtOYlc4+sqcycpa0VBGrww2anEJmA=";
              };
            };
            pnpm-nvim = pkgs.vimUtils.buildVimPlugin {
              pname = "pnpm.nvim";
              version = "2025-04-02";
              src = pkgs.fetchFromGitHub {
                owner = "lukahartwig";
                repo = "pnpm.nvim";
                rev = "b44002c8da2ef68a023ff2c3fa2c454c6c7fa279";
                hash = "sha256-iJ7f4+nB04rlkLr/faCrBUsbgiRT7f9IDQMM0R6xT9M=";
              };
            };
            # TODO: Use upstream package once it is updated to include the
            # license, and thus is no longer considered "non-free".
            nvim-highlight-colors = pkgs.vimUtils.buildVimPlugin {
              pname = "nvim-highlight-colors";
              version = "2026-05-07";
              src = pkgs.fetchFromGitHub {
                owner = "brenoprata10";
                repo = "nvim-highlight-colors";
                rev = "e4c7af0211866162d999ce0bdd6a029302e19139";
                hash = "sha256-4tkehMJpMs/CrQrCFqy+4G9uQei9mAoQlwvxuYtu7z8=";
              };
              nvimSkipModules = [
                "nvim-highlight-colors.color.converters_spec"
                "nvim-highlight-colors.color.patterns_spec"
                "nvim-highlight-colors.color.utils_spec"
                "nvim-highlight-colors.buffer_utils_spec"
                "nvim-highlight-colors.utils_spec"
              ];
            };
          };
        }
      );
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
          droid = self.wrappers.droid.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
          prettier-with-plugins = pkgs.callPackage ./packages/prettier-with-plugins.nix { };
        }
      );
      checks = forAllSystems (
        system: self.packages.${system} // self.legacyPackages.${system}.vimPlugins
      );
      nixosModules = {
        neovim = wrappers.lib.getInstallModule {
          name = "neovim";
          value = neovimModule;
        };
        droid = wrappers.lib.getInstallModule {
          name = "neovim";
          value = droidModule;
        };
        default = self.nixosModules.neovim;
      };
      homeModules = {
        neovim = self.nixosModules.neovim;
        droid = self.nixosModules.droid;
        default = self.homeModules.neovim;
      };
    };
}
