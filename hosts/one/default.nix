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
      ../../configs/cli/min.nix
      ../../configs/cli/starship.nix
      ../../configs/cli/fzf.nix
      ../../configs/cli/direnv.nix
      ../../configs/git.nix
    ];
    home.stateVersion = stateVersion;
  };


  system.stateVersion = stateVersion;


  user = {
    shell = "${pkgs.zsh}/bin/zsh";
    username = "qq";
  };
}
