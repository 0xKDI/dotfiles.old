{ config, pkgs, ... }:

{
  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    options = [ "fzf" ];
  };


  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd -HL --type d --exclude .git";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--select-1"
      "--reverse"
      "--multi"
      "--info=inline"
      "--color=dark"
      "--color=fg:7,bg:-1,hl:#5fff87,fg+:15,bg+:-1,hl+:#ffaf5f"
      "--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
    ];
    fileWidgetCommand = "fd -H -t f";
    fileWidgetOptions = [
      "--preview='bat"
      "--style=numbers"
      "--color=always {}"
    ];
  };
}
