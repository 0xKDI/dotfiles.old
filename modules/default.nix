{ config, pkgs, lib, ... }:

{
  imports = [
    ./aws.nix
    ./python.nix
    ./latex.nix
  ];
}
