{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gh
    libqalculate
    wally-cli

    minikube
    kubectl
    kubernetes-helm
    awscli2
    doctl
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

    file
    scc
    tealdeer # faster tldr
    manix
    youtube-dl
    imagemagick

    # archive
    unrar
    p7zip
  ];
}
