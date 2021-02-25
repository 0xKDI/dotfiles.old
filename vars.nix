{ config, pkgs, lib, ... }:

with lib; {
  options = {
    d = {
      user = mkOption {
        default = "qq";
        type = types.str;
      };

      uid = mkOption {
        default = 1000;
        type = types.int;
      };

      dir = mkOption {
        default =  builtins.toString ./.;
        type = types.path;
      };
    };
  };
}
