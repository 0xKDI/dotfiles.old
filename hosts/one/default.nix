{ pkgs, ... }:

let
  stateVersion = "20.09";
in
{
  home-manager.config = { pkgs, ... }:
    {
      imports = [
        ../../configs
      ];


      programs = {
        home-manager.enable = true;
        jq.enable = true;
        htop.enable = true;
        ssh.enable = true;
        bat.enable = true;
        z-lua.enable = true;
        fzf.enable = true;
        direnv.enable = true;
        starship.enable = true;
        # neovim.enable = true;
        tmux.enable = true;
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
