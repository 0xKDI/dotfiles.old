{ config, pkgs, ... }:

let
  user = config.d.user;
  host = baseNameOf ./.;
in
{
  imports = [
    ./hardware-configuration.nix
  ];


  # this is only increases boot time
  systemd.services.NetworkManager-wait-online.enable = false;


  powerManagement.cpuFreqGovernor = "performance";


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
