{ config, pkgs, ... }:

let
  email = "0qqw0qqw@gmail.com";
  user = config.home.username;
in
{
  programs.git = {
    enable = true;
    userEmail = email;
    userName = user;
    ignores = [
      "Session.vim"
    ];
    aliases = {
      s = "status";
      c = "commit";
      co = "checkout";
      a = "add";
      b = "branch";
      l = "log";
      lo = "log --oneline";
      sw = "switch";
      rb = "rebase -i";
    };
    extraConfig = {
      pull.ff = "only";
    };
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations side-by-side line-numbers";
        whitespace-error-style = "22 reverse";
      };
    };
  };


  programs.zsh.shellAliases = {
    g = "git";
    gs = "git status";
  };
}
