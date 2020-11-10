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
        sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
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
  # FIXME: this doesn't mask service
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

  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [ "Iosevka" "JetBrainsMono" "FiraCode" ];
    })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

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

  virtualisation.virtualbox.host = {
    enable = true;
    package = pkgs.virtualbox;
  };

  # remap the most useless key to the most useful one
  # (Caps lock become Ctrl when used with another key and Esc when used without one)
  services.interception-tools.enable = true;

}
