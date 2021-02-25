{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
      sxiv
  ];


  xdg.configFile = {
    "sxiv/exec/key-handler".source = ./key-handler;
    "sxiv/exec/image-info".source = ./image-info;
  };
}
