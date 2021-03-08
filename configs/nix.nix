{ config, pkgs, ... }:

{
  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowunfree = true; }
  '';


  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes ca-references
    substituters = https://cache.nixos.org https://nix-community.cachix.org
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
  '';
}
