{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:rycee/home-manager";
    nur.url = "github:nix-community/NUR";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
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
          ./vars.nix
          ./hosts/xia
          ./hosts/nixos-common.nix
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = overlays;
          }
        ];
      };
    };
}
