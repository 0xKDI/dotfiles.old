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
      bindkey '\eq' fzf-cd-widget
      bindkey '\er' fzf-history-widget
    '';
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      fs = "f -S";

      tf = "terraform";

      k = "kubectl";
      ka = "kubectl apply";
      kg = "kubectl get";
      kd = "kubectl describe";
      ke = "kubectl explain";
      kdel = "kubectl delete";

      dst = "dust -r";
      s = "ddgr";
      dkr = "docker";
      trr = "transmission-remote";

      n = "noti";

      py3 = "python3";
      py2 = "python2";
      py = "python3";

      mkdir = "mkdir -p";

      b = "buku --suggest";
      v = "nvim";

      # systemd
      se = "sudoedit";

      # systemlevel
      start = "sudo systemctl start";
      stop = "sudo systemctl stop";
      restart = "sudo systemctl restart";
      status = "sudo systemctl status";
      enable = "sudo systemctl enable";
      disable = "sudo systemctl disable";

      # userlevel
      ustart = "systemctl --user start";
      ustop = "systemctl --user stop";
      urestart = "systemctl --user restart";
      ustatus = "systemctl --user status";
      uenable = "systemctl --user enable";
      udisable = "systemctl --user disable";

      "..." = "cd ../..";
      "...." = "cd ../../..";
      Q = "cd ~ ; clear";

      sxiv = "sxiv -b";
      zt = "devour zathura";

      # exa
      l = "exa -al --group-directories-first";
      ll = "exa -a --group-directories-first";
      lt = "exa -a --tree --group-directories-first";
      L = "exa -l --group-directories-first";

      # git
      g = "git";
      gs = "git status";

      y = "xclip -selection c";
      p = "xclip -selection c -o";
      qr = ''
        xclip -selection c -o |
        qrencode -o /tmp/grencode.png;
        devour sxiv -b /tmp/grencode.png
      '';
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
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
          sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        };
        file = "autopair.zsh";
      }
      {
        name = "zsh-system-clipboard";
        src = fetchFromGitHub {
          owner = "kutsan";
          repo = "zsh-system-clipboard";
          rev = "v0.7.0";
          sha256 = "09lqav1mz5zajklr3xa0iaivhpykv3azkjb7yj9wyp0hq3vymp8i";
        };
        file = "zsh-system-clipboard.zsh";
      }
    ];
  };
}
