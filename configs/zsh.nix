{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    history.path = "${config.xdg.cacheHome}/zsh/history";
    initExtra = ''
      autoload -Uz edit-command-line; zle -N edit-command-line
      bindkey '^ ' edit-command-line
    '';
    shellAliases = {
      dkr = "docker";

      mkdir = "mkdir -p";

      "..." = "cd ../..";
      "...." = "cd ../../..";
      Q = "cd ~ ; clear";
    };
    plugins = with pkgs; [
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-autopair";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
        file = "autopair.zsh";
      }
    ];
  };
}
