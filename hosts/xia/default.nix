{ config, pkgs, ... }:

let
  user = "qq";
  host = baseNameOf ./.;
  uid = 1000;
  home = "/home/${user}";
  stateVersion = "22.11";
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
          libsForQt5.kdenlive
          unstable.istioctl
          unstable.fluxcd
          rclone
          openconnect
          teams
          pdftk
          sysstat
          lftp
          arandr
          ipcalc
          openldap
          envsubst
          inetutils
          xst
          discord
          unstable.tdesktop
          skypeforlinux
          slack
          drawio
          libreoffice-fresh
          spotifywm
          sysstat
          gimp
          syncthing-cli #stcli
          remmina

          mpvc # a mpc-like control interface for mpv
          graphviz
          wally-cli
          imagemagick
          pandoc
          pavucontrol
          cadaver

          transmission
          unstable.youtube-dl

          ddgr # DuckDuckGo-cli
          googler
          gh

          unstable.delve

          unrar
          p7zip
          inotify-tools
          libqalculate
          sshfs

          # docker-credential-helpers
          docker-compose
          runc
          kompose
          podman

          minikube
          docker-machine-kvm2
          kubectl
          kubernetes-helm
          helmfile
          kops

          doctl

          terraform
          terraform-ls
          terragrunt
          unstable.ansible
          ansible-lint
          unstable.minio-client

          maven
          gradle

          openfortivpn
          samba
          groovy

          mongodb-compass
          # mongodb-4_2 # pls somebody push this to cachix
          mongodb-tools

          pgcli
          postgresql_14

          sops
          vagrant
          # pythonFull
          brave
          vault

          asciinema
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
        # browserpass.enable = true;
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
        "wireshark"
        "networkmanager"
        "audio"
        "vboxusers"
        "docker"
        "plugdev"
        "adbusers"
        "libvirtd"
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
    settings = {
      trusted-users = [ "root" "${user}" ];
      max-jobs = 6;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };


  nixpkgs.config.allowUnfree = true;


  systemd.services = {
    NetworkManager-wait-online.enable = false; # this is only increases boot time
    # https://wiki.archlinux.org/title/OpenVPN#Client_daemon_not_reconnecting_after_suspend
    # openvpn-reconnect = {
    #   enable = true;
    #   description = "Restart OpenVPN after suspend";
    #   serviceConfig = {
    #     ExecStart = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
    #   };
    #   wantedBy = [ "multi-user.target" "sleep.target" ];
    # };
    openfortivpn-dit = {
      enable = true;
      after = [ "network-online.target" ];
      description = "OpenFortiVPN for dit";
      documentation = [ "man:openfortivpn(1)" ];
      serviceConfig = {
        Type = "notify";
        PrivateTmp = true;
        ExecStart = "${pkgs.openfortivpn}/bin/openfortivpn -c /root/nixos/openfortivpn/dit/default.conf";
        OOMScoreAdjust = -100;
      };
      requires = [ "openfortivpn-dit-routes.service" ];
    };
    openfortivpn-dit-routes = {
      enable = true;
      path = [
        "${pkgs.bash}"
        "${pkgs.coreutils}"
        "${pkgs.iproute2}"
        "${pkgs.gawk}"
      ];
      after = [ "openfortivpn-dit.service" ];
      description = "Add dit custom vpn routes";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/root/nixos/openfortivpn/dit/custom-routes.sh";
      };
    };
  };


  powerManagement.cpuFreqGovernor = "powersave";


  time.timeZone = "Europe/Moscow";


  sound.enable = true;


  networking = {
    networkmanager.enable = true;
    hostName = "${host}";
    firewall = {
      allowedTCPPorts = [ 80 443 22000 ];
      allowedUDPPorts = [ 80 443 ];
    };
    extraHosts = ''
      10.206.247.50 ipev2-infr-k8s-01t.data.corp 
      10.206.213.168 ipev2-infr-k8s-01p
      10.206.249.1 ipev2-infr-k8s-01i.data.corp
    '';
  };


  services = {
    # remap the most useless key to the most useful one
    # (Caps lock become Ctrl when used with another key and Esc when used without one)
    # https://github.com/NixOS/nixpkgs/issues/126681
    # interception-tools = {
    # enable = true;
    # plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    # udevmonConfig = ''
    #   - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
    #     DEVICE:
    #       EVENTS:
    #         EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    # '';
  # };
    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
    tlp = {
      enable = true;
      settings = {
        RUNTIME_PM_DRIVER_BLACKLIST = "nouveau nvidia";
        RUNTIME_PM_ON_AC = "auto";
      };
    };
    openvpn.servers = let vpnCfg = dst: {
        config = "config /root/nixos/openvpn/${dst}/default.conf"; 
        autoStart = false;
        updateResolvConf = true;
    }; in {
      td  = vpnCfg "td";
      usa  = vpnCfg "usa";
      uk  = vpnCfg "uk";
      tmp  = vpnCfg "tmp";
    };
  };


  services.xserver = {
    enable = true;
    videoDrivers = [ "modesettings" ];
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
    dconf.enable = true;
    browserpass.enable = true;
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    java = {
      enable = true;
      # package = pkgs.jdk11;
      package = pkgs.jdk8;
    };
  };


  environment.pathsToLink = [ "/share/zsh" ]; # get zsh completion for system packages

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
    };
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    docker = {
      package = pkgs.unstable.docker;
      enable = true;
      enableOnBoot = false;
      extraOptions = ''
      --config-file=${pkgs.writeText "daemon.json" (builtins.toJSON
      {
        insecure-registries = [
          "localhost:8081"
          "10.15.61.1:5007"
          "10.15.61.1:5002"
        ];
      }
      )}
      '';
    };
  };


  i18n.defaultLocale = "en_US.UTF-8";


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
