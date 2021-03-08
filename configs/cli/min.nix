{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    coreutils
    file
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
    jq.enable = true;
    htop.enable = true;
    ssh.enable = true;
  };


  programs.zsh.shellAliases = {
    l = "exa -al --group-directories-first";
    ll = "exa -a --group-directories-first";
    lt = "exa -a --tree --group-directories-first";
    L = "exa -l --group-directories-first";
  };
}
