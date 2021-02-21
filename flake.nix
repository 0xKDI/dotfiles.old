{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:rycee/home-manager";
    nur.url = "github:nix-community/NUR";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, nur, neovim-nightly-overlay }:
  let
    overlays = [
      nur.overlay
      neovim-nightly-overlay.overlay
      (self: super: {
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
      })
    ];
  in
  {
    nixosConfigurations.xia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./lib
        ./hosts/xia
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
        }
      ];
    };
  };
}
