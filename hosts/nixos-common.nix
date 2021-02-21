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
