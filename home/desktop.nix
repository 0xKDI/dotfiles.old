{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    drawio
    tdesktop
    libreoffice-fresh

    gimp
    sxiv

    (nerdfonts.override {
      fonts = [
        "Iosevka"
        "JetBrainsMono"
        "FiraCode"
        "FantasqueSansMono"
      ];
    })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];


  fonts.fontconfig.enable = true;


  xsession.pointerCursor = {
    package = pkgs.capitaine-cursors;
    size = 20;
    name = "capitaine-cursors";
  };


  gtk = {
    enable = true;
    gtk3.bookmarks = [
      "file:///home/${config.home.username}/uni"
      "file:///home/${config.home.username}/prj"
      "file:///home/${config.home.username}/bks"
      "file:///home/${config.home.username}/snc"
    ];
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };


  # FIXME: Vbox doesn't care
  qt = {
    enable = true;
    platformTheme = "gnome";
  };


  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "/dev/null";
      publicShare = "/dev/null";
      music = "/dev/null";
      templates = "/dev/null";
      download = "$HOME/dl";
      pictures = "$HOME/pic";
      videos = "$HOME/vid";
      documents = "$HOME/dcs";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "sxiv.desktop";
        "image/png" = "sxiv.desktop";
      };
    };
  };
}
