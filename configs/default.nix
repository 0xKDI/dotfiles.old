{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
in
{
  imports = [
    ../vars.nix
    ./alacritty.nix
    ./bspwm.nix
    ./desktop.nix
    ./dunst.nix
    ./firefox.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./latex.nix
    ./mpv.nix
    ./neovim
    ./polybar
    ./python.nix
    ./starship.nix
    ./st.nix
    ./sxhkd.nix
    ./sxiv
    ./systemd.nix
    ./terraform.nix
    ./tmux
    ./xsession.nix
    ./zathura.nix
    ./zsh.nix
  ];


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

    qrencode # for QR-code

    # essential
    gnumake
    gcc
    gdb
    coreutils
    killall
    curl
    wget

    file
    scc
    tree
    exa
    fd
    ripgrep
    tealdeer # faster tldr
    manix
    progress
    youtube-dl
    imagemagick


    # archive
    unrar
    p7zip
  ];


  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Dracula";
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${home}/.password-store";
      };
    };
    home-manager.enable = true;
    noti.enable = true;
    jq.enable = true;
    htop.enable = true;
    ssh.enable = true;
    gpg.enable = true;
  };


  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 28800;
      defaultCacheTtlSsh = 28800;
    };
    screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    };
    syncthing.enable = true;
    unclutter.enable = true; # hide cursor when it's not used
    clipmenu.enable = true;
  };
}
