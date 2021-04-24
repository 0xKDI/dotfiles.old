{ config, pkgs, lib, ... }:

with lib;
let
  # Automatically import all *.nix files
  # except default.nix in current dir
  mapModules = set:
  let 
    filter = k: v: k != "default.nix" &&
      (hasSuffix ".nix" k || v == "directory");
    paths = filterAttrs filter set;
  in
  mapAttrsToList (k: v: ./. + "/${k}") paths ;
in
{
  imports = mapModules (builtins.readDir ./.);
}
