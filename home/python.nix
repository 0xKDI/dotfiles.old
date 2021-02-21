{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python38
    python38Packages.ipython
    python38Packages.pip
  ];


  xdg.configFile."pythonrc.py".source = "${config.dots.confDir}/pythonrc";
}
