{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      newSession = true;
      tmuxp.enable = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        fzf-tmux-url
      ];
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
