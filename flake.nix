{
  description = "NixOS configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { self, ... }@inputs:
    let
      overlays = [
        (import ./overlays)
        (self: super: {
          unstable = import inputs.nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        })
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
    };
}
