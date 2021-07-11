{ pkgs, ... }:

let
  stateVersion = "20.09";
in
{
  home-manager.config = { pkgs, ... }:
    {
      imports = [
        ../common.nix
      ];


      modules = {
        # neovim.enable = true;
        # tmux.enable = true;
      };


      programs = {
        home-manager.enable = true;
        jq.enable = true;
        htop.enable = true;
        ssh.enable = true;
        bat.enable = true;
        z-lua.enable = true;
        fzf.enable = true;
        starship.enable = true;
        git.enable = true;
        password-store.enable = true;
        zsh.enable = true;
      };


      home.stateVersion = stateVersion;


      fonts.fontconfig.enable = true;
    };


  system.stateVersion = stateVersion;


  user.shell = "${pkgs.zsh}/bin/zsh";
}
