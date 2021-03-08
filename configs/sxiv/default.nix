{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    sxiv
    qrencode # for QR-code
  ];


  xdg.configFile = {
    "sxiv/exec/key-handler".source = ./key-handler;
    "sxiv/exec/image-info".source = ./image-info;
  };


  programs.zsh.shellAliases = {
    sxiv = "sxiv -b";
    qr = ''
        xclip -selection c -o |
        qrencode -o /tmp/grencode.png;
        devour sxiv -b /tmp/grencode.png
    '';
  };
}
