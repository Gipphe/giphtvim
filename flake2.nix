{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
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
      wrapper = wrappers.lib.evalModule module;
    in
    {
      wrapperModules = {
        neovim = module;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
        }
      );
      nixosModules = {
        neovim = wrappers.lig.getInstallModule {
          name = "neovim";
          value = module;
        };
        default = self.nixosModules.neovim;
      };
      homeModules = {
        neovim = self.nixosModules.neovim;
        default = self.homeModules.neovim;
      };
    };
}
