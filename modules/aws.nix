{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.programs.aws;
in
{
  options.programs.aws = {
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
