{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./cpu.nix
    ./gpu.nix
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.pulseaudio.configFile = let inherit (pkgs) runCommand pulseaudio;
  paConfigFile = runCommand "disablePulseaudioEsoundModule"
  { buildInputs = [ pulseaudio ]; } ''
        mkdir "$out"
        cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
        sed -i -e 's|load-module module-esound-protocol-unix|# ...|' \
                -e 's|load-module module-suspend-on-idle|# ...|' \
        "$out/default.pa"
  '';
  in "${paConfigFile}/default.pa";

  networking = {
    networkmanager.enable = true;
    hostName = "${config.dots.hostName}";
    firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false; #this is only increases boot time

  time.timeZone = "Europe/Moscow";

  services.tlp.enable = true;

  # touchpad
  services.xserver.libinput = {
    enable = true;
    # idk why it isn't default
    naturalScrolling = true;
  };

  services.xserver = {
    enable = true;
    layout = "us,ru";
    # xkbOptions = "caps:escape";
    # xkbOptions = "caps:ctrl_modifier";
  };

  services.xserver.displayManager = {
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

  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # NOTE:nix-zsh-completions doesn't work without enabling zsh system wide
  programs.zsh = {
    enable = true;
    # useless since home-manager runs compinit anyway
    enableGlobalCompInit = false;
  };

  # for firefox
  services.psd = {
    enable = true;
    resyncTimer = "30min";
  };

  virtualisation.virtualbox = {
    host.enable = true;
    # host.enableExtensionPack = true;
  };

  virtualisation.docker.enable = true;

  # remap the most useless key to the most useful one
  # (Caps lock become Ctrl when used with another key and Esc when used without one)
  services.interception-tools.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  programs.bash.interactiveShellInit = ''HISTFILE="$XDG_DATA_HOME"/bash/history'';

}
