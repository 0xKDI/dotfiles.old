{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.modules.aws;
in
{
  options.modules.aws = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      awscli2
    ];
  };
}
