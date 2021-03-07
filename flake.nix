{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:rycee/home-manager";
    nur.url = "github:nix-community/NUR";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-on-droid.url = "github:t184256/nix-on-droid/master";
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
          {
            nixpkgs.overlays = overlays;
          }
        ];
      };

      one = (inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
        config = import ./hosts/one;
      }).activationPackage;
    };
}
