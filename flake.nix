{
  description = "NixOS configuration";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-21.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      # url = "path:/home/qq/prj/home-manager";
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
        (self: super: {
          stable = import inputs.nixpkgs-stable {
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


      one = (inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
        config = { pkgs, config, ... }:
        {
          imports = [ ./hosts/one ];
          home-manager.config.nixpkgs.overlays = overlays; 
        };
      }).activationPackage;
    };
}
