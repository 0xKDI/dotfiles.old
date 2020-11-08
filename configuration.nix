{ config, pkgs, ... }:

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
  # nix.package = pkgs.nixUnstable;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import <nur> {
      inherit pkgs;
    };
  };



  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.dots.userName} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
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

