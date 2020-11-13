{ config, pkgs, options, ... }:

{

  imports = [
    <home-manager/nixos>
    ./hardware
    ./options.nix
  ];

  # burn /tmp
  boot.cleanTmpDir = true;

  # Fix a security hole in place for backwards compatibility. See desc in
  # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
  boot.loader.systemd-boot.editor = false;

  nix.autoOptimiseStore = true;
  nix.trustedUsers = [ "root" "${config.dots.userName}" ];
  nix.nixPath = options.nix.nixPath.default ++ [
    "nixpkgs-overlays=/etc/nixos/overlays-compat/"
  ];

  # nix.package = pkgs.nixUnstable;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import <nur> {
      inherit pkgs;
    };
    unstable = import <unstable> {
      inherit pkgs;
    };
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/mjlbach/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];



  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  users.users.${config.dots.userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "vboxusers"
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
      imports = [ ./home.nix ];
    };
  };


  system.stateVersion = "20.09";
}

