{ pkgs, ... }:

let 
  stateVersion = "20.09";
in
{
  system.stateVersion = stateVersion;


  home-manager.config = { pkgs, ... }:
  {
    imports = [
      ../../configs/nix.nix
    ];
    home.stateVersion = stateVersion;
  };
}
