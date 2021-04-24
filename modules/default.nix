{ config, pkgs, lib, ... }:

with lib;
let
  # Automatically import all *.nix files
  # except default.nix in current dir
  filter = k: v: k != "default.nix" && hasSuffix ".nix" k;
  filteredFiles = filterAttrs filter (builtins.readDir ./.);
  moduleFiles = mapAttrsToList (k: v: ./. + "/${k}") filteredFiles;
in
{
  imports = moduleFiles;
}
