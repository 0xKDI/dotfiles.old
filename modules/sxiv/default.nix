{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.modules.sxiv;
in
{
  options.modules.sxiv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sxiv
      qrencode # for QR-code
    ];


    xdg.configFile = {
      "sxiv/exec/key-handler".source = ./key-handler;
      "sxiv/exec/image-info".source = ./image-info;
    };
  };
}
