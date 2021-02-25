{ config, pkgs, lib, ... }:

with lib; {
  options = {
    d = {
      dir = mkOption {
        default =  builtins.toString ./.;
        type = types.path;
      };
    };
  };
}
