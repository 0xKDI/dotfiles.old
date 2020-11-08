{ config, pkgs, lib, ... }:

with lib; {
  options = {
    dots = {

      userName = mkOption {
        default = "qq";
        type = types.str;
      };

      hostName = mkOption {
        default = "xia";
        type = types.str; 
      };

      # paths
      dotDir = mkOption {
        default = "/etc/nixos";
        type = types.path;
      };

      confDir = mkOption {
        default = "${config.dots.dotDir}/config";
        type = types.path;
      };

      binDir = mkOption {
        default = "${config.dots.dotDir}/bin";
        type = types.path;
      };

    };
  };
}

