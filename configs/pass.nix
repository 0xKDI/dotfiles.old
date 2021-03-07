{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${home}/.password-store";
    };
  };
}
