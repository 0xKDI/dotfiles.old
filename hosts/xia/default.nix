{ config, pkgs, ... }:

let
  user = "qq";
  host = baseNameOf ./.;
  uid = 1000;
  home = "/home/${user}";
  stateVersion = "21.05";
in
{
  imports = [
    ./hardware-configuration.nix
  ];


  home-manager = {
    users.${user} = {
      imports = [
        ../common.nix
      ];
      home = {
        stateVersion = stateVersion;
        username = "${user}";
        homeDirectory = "${home}";
        packages = with pkgs; [
          xst
          sqlite # required for buku
          stable.discord
          drawio
          tdesktop
          libreoffice-fresh
          spotifywm
          mpvc # a mpc-like control interface for mpv
          gimp
          graphviz
          docker-credential-helpers
          docker-compose
          wally-cli

          gh
          libqalculate

          transmission

          du-dust # du + rust
          ddgr # DuckDuckGo-cli
          googler

          lsof
          nmap
          openssl
          tcpdump
          acpi
          inotify-tools

          syncthing-cli #stcli
          gnumake
          gcc
          gdb

          scc
          tealdeer # faster tldr
          manix
          youtube-dl
          imagemagick

          unrar
          p7zip

          minikube
          kubectl
          kubernetes-helm
          kops

          doctl

          terraform_0_15
          terraform-ls

          qrencode # for QR-code

          pandoc
          nixpkgs-fmt
        ];
      };
      modules = {
        aws.enable = true;
        python.enable = true;
        latex.enable = true;
        sxhkd.enable = true;
        neovim.enable = true;
        sxiv.enable = true;
        tmux.enable = true;
      };
      programs = {
        home-manager.enable = true;
        jq.enable = true;
        htop.enable = true;
        ssh.enable = true;
        gpg.enable = true;
        noti.enable = true;
        go.enable = true;
        bat.enable = true;
        zoxide.enable = true;
        fzf.enable = true;
        direnv.enable = true;
        starship.enable = true;
        alacritty.enable = true;
        firefox.enable = true;
        browserpass.enable = true;
        git.enable = true;
        mpv.enable = true;
        password-store.enable = true;
        zathura.enable = true;
        zsh.enable = true;
      };
      services = {
        gpg-agent.enable = true;
        udiskie.enable = true;
        syncthing.enable = true;
        unclutter.enable = true;
        clipmenu.enable = true;
        dunst.enable = true;
        polybar.enable = true;
      };
      gtk.enable = true;
      xdg = {
        enable = true;
        userDirs.enable = true;
        mimeApps.enable = true;
      };
      fonts.fontconfig.enable = true;
      xsession = {
        enable = true;
        windowManager.bspwm.enable = true;
      };
      systemd.user.startServices = "legacy";
    };
    useUserPackages = true;
    useGlobalPkgs = true;
  };


  users.users.${user} = {
    isNormalUser = true;
    uid = uid;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "vboxusers"
      "docker"
      "plugdev"
      "adbusers"
    ];
    shell = pkgs.zsh;
    initialPassword = "nix";
  };


  system.stateVersion = stateVersion;


  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    trustedUsers = [ "root" "${user}" ];
    maxJobs = 6;
  };


  nixpkgs.config.allowUnfree = true;


  # this is only increases boot time
  systemd.services.NetworkManager-wait-online.enable = false;


  powerManagement.cpuFreqGovernor = "powersave";


  time.timeZone = "Europe/Moscow";


  sound.enable = true;


  networking = {
    networkmanager.enable = true;
    hostName = "${host}";
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };
  };


  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    # remap the most useless key to the most useful one
    # (Caps lock become Ctrl when used with another key and Esc when used without one)
    interception-tools.enable = true;
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
    psd = {
      enable = true;
      resyncTimer = "30min";
    };
    tlp.enable = true;
  };


  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];
    useGlamor = true;
    layout = "us,ru";
    # xkbOptions = "caps:escape";
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${user}";
      };
      defaultSession = "none+home-manager";
      session = [{
        name = "home-manager";
        manage = "window";
        start = ''
          ${pkgs.stdenv.shell} $HOME/.xsession &
          waitPID=$!
        '';
      }];
    };
    libinput = {
      enable = true;
      # idk why it isn't default
      touchpad.naturalScrolling = true;
    };
  };


  programs = {
    bash.interactiveShellInit = ''HISTFILE="$XDG_DATA_HOME"/bash/history'';
    adb.enable = true;
  };


  environment.pathsToLink = [ "/share/zsh" ]; # get zsh completion for system packages


  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    docker = {
      enable = true;
      enableOnBoot = false;
      extraOptions = "--registry-mirror=https://mirror.gcr.io";
    };
  };


  i18n.defaultLocale = "en_US.UTF-8";


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
