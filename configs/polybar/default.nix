{ config, pkgs, ... }:

{
  services.polybar = {
    enable = true;
    script = "polybar main &";
    package = pkgs.polybar.override {
      pulseSupport = true;
      nlSupport = true;
    };
    config = ./config;
  };
}
