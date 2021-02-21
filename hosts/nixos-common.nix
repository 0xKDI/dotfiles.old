{ config, pkgs, ... }:

let
  user = config.dots.userName;
  uid = config.dots.uid;
  host = config.dots.hostName;
  home = "/home/${user}";
  stateVersion = "21.03";
in
  {

    system.stateVersion = stateVersion;


    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      autoOptimiseStore = true;
      trustedUsers = [ "root" "${user}" ];
      maxJobs = 8;
      binaryCaches = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
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
      ];
      shell = pkgs.zsh;
      initialPassword = "nix";
    };


    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${user} = {
        home = {
          stateVersion = stateVersion;
          username = "${user}";
          homeDirectory = "${home}";
        };
        imports = [ "${config.dots.dotDir}/modules" ];
        xdg.configFile."nixpkgs/config.nix".text = ''
          { allowUnfree = true; }
        '';
      };
    };
  }
