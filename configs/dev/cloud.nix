{ config, pkgs, ... }:

let
  configHome = config.xdg.configHome;
  cacheHome = config.xdg.cacheHome;
in
{
  home.packages = with pkgs; [
    awscli2
    doctl
  ];


  home.sessionVariables = {
    AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${configHome}/aws/config";
  };
}
