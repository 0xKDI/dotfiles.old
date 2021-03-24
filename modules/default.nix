{ config, pkgs, lib, ... }:

{
  imports = [
    ./python.nix
    ./latex.nix
  ];
}
