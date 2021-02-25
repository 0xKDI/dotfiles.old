{ config, pkgs, lib, ... }:

with lib; {
  options = {
    dir = mkOption {
      default =  builtins.toString ./.;
      type = types.path;
    };
  };
}
