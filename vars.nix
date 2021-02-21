{ config, pkgs, lib, ... }:

with lib; {
  options = {
    dots = {
      userName = mkOption {
        default = "qq";
        type = types.str;
      };

      uid = mkOption {
        default = 1000;
        type = types.int;
      };

      hostName = mkOption {
        default = "xia";
        type = types.str; 
      };

      # paths
      dotDir = mkOption {
        default =  builtins.toString ./.;
        type = types.path;
      };
    };
  };
}
