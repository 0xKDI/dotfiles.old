{ config, pkgs, ... }:

{
  imports = [
    ./direnv.nix
    ./fzf.nix
    ./min.nix
    ./starship.nix
    ./utils.nix
  ];
}
