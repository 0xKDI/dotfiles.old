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
          stable.discord
          skypeforlinux
          drawio
          tdesktop
          libreoffice-fresh
          spotifywm
          gimp
          syncthing-cli #stcli

          mpvc # a mpc-like control interface for mpv
          graphviz
          wally-cli
          imagemagick
          pandoc

          transmission
          youtube-dl

          ddgr # DuckDuckGo-cli
          googler
          gh

          unrar
          p7zip
          inotify-tools
          libqalculate
          sshfs

          docker-credential-helpers
          docker-compose
          kompose

          minikube
          kubectl
          kubernetes-helm
          kops

          doctl

          terraform_0_15
          terraform-ls
          ansible

          openfortivpn
          samba
          maven
          groovy
        ];
      };
      modules = {
        aws.enable = true;
        python.enable = true;
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
        screen-locker.enable = true;
        sxhkd.enable = true;
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
    };
    useUserPackages = true;
    useGlobalPkgs = true;
  };


  users = {
    users.${user} = {
      isNormalUser = true;
      uid = uid;
      group = "${user}";
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
    groups.${user} = { gid = uid; };
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
    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
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
    # https://github.com/NixOS/nixpkgs/issues/126681
    interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
    psd = {
      enable = true;
      resyncTimer = "30min";
    };
    tlp = {
      enable = true;
      settings = {
        RUNTIME_PM_DRIVER_BLACKLIST = "nouveau nvidia";
        RUNTIME_PM_ON_AC = "auto";
      };
    };
    openvpn.servers.work  = {
      config = '' config /root/nixos/openvpn/work.conf ''; 
      autoStart = false;
      updateResolvConf = true;
    };
  };


  services.xserver = {
    enable = true;
    videoDrivers = [ "modesettings" ];
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
    java = {
      enable = true;
      package = pkgs.jdk11;
    };
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
