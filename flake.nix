{
  description = "NixOS configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, ... }@inputs:
    let
      overlays = [
        inputs.nur.overlay
        inputs.neovim-nightly-overlay.overlay
        (import ./overlays)
      ];
    in
    {
      nixosConfigurations.xia = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/xia
          inputs.home-manager.nixosModules.home-manager
          { nixpkgs.overlays = overlays; }
        ];
      };


      one = (inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
        config = import ./hosts/one;
      }).activationPackage;
    };
}
