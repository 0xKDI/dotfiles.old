{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    coreutils
    killall
    curl
    wget
    exa
    fd
    ripgrep
    progress
    tree
  ];


  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Dracula";
      };
    };
    home-manager.enable = true;
    noti.enable = true;
    jq.enable = true;
    htop.enable = true;
    ssh.enable = true;
  };
}
