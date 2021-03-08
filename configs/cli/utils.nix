{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    libqalculate
    wally-cli

    docker-credential-helpers

    graphviz
    transmission

    du-dust # du + rust
    ddgr # DuckDuckGo-cli
    googler
    cachix

    lsof
    nmap
    openssl
    tcpdump

    syncthing-cli #stcli

    # essential
    gnumake
    gcc
    gdb

    scc
    tealdeer # faster tldr
    manix
    youtube-dl
    imagemagick

    # archive
    unrar
    p7zip
  ];


  programs.zsh.shellAliases = {
    dst = "dust -r";
    s = "ddgr";
    trr = "transmission-remote";
  };
}
