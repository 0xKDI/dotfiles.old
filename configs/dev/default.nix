{ config, pkgs, ... }:

{
  imports = [
    ./go.nix
    ./python.nix
    ./terraform.nix
  ];
}
