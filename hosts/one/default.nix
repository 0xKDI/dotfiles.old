{ pkgs, ... }:

let 
  stateVersion = "20.09";
in
{
  home-manager.config = { pkgs, ... }:
  {
    imports = [
      ../../configs/nix.nix
      ../../configs/zsh.nix
    ];
    home.stateVersion = stateVersion;
  };


  system.stateVersion = stateVersion;


  user = {
    shell = "${pkgs.zsh}/bin/zsh";
    username = "qq";
  };
}
