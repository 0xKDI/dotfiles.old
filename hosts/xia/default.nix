{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];


  system.stateVersion = "21.03";


  systemd.services.NetworkManager-wait-online.enable = false; #this is only increases boot time

  powerManagement.cpuFreqGovernor = "performance";


  time.timeZone = "Europe/Moscow";


  sound.enable = true;


  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    trustedUsers = [ "root" "${config.dots.userName}" ];
    maxJobs = 8;
  };


  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        vimPlugins = pkgs.vimPlugins // pkgs.callPackage ../../pkgs/vimPlugins.nix {};
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
  };


  users.users.${config.dots.userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "vboxusers"
      "docker"
      "plugdev"
    ];
    shell = pkgs.zsh;
    initialPassword = "nix";
  };


  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${config.dots.userName} = {
      home = {
        stateVersion = "${config.system.stateVersion}";
        username = "${config.dots.userName}";
        homeDirectory = "/home/${config.dots.userName}";
      };
      imports = [ "${config.dots.dotDir}/home" ];
    };
  };


  networking = {
    networkmanager.enable = true;
    hostName = "${config.dots.hostName}";
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
        user = "${config.dots.userName}";
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


  # nix-zsh-completions doesn't work without enabling zsh system wide
  programs = {
    zsh = {
      enable = true;
      # useless since home-manager runs compinit anyway
      enableGlobalCompInit = false;
    };
    bash.interactiveShellInit = ''HISTFILE="$XDG_DATA_HOME"/bash/history'';
  };


  virtualisation = {
    virtualbox.host.enable = true;
    docker = {
      enable = true;
      enableOnBoot = false;
    };
  };


  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
