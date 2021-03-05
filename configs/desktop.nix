{ config, pkgs, ... }:

let
  home = config.home.homeDirectory;
  univercityDir = "${home}/uni";
  projectDir = "${home}/prj";
  booksDir = "${home}/bks";
  syncDir = "${home}/snc";
  downloadDir = "${home}/dl";
  picturesDir = "${home}/pic";
  videosDir = "${home}/vid";
  documentsDir = "${home}/dcs";
in
{
  home.packages = with pkgs; [
    discord
    drawio
    tdesktop
    libreoffice-fresh
    spotifywm

    gimp

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
      "file://${univercityDir}"
      "file://${projectDir}"
      "file://${booksDir}"
      "file://${syncDir}"
    ];
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };


  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "/dev/null";
      publicShare = "/dev/null";
      music = "/dev/null";
      templates = "/dev/null";
      download = "${downloadDir}";
      pictures = "${picturesDir}";
      videos = "${videosDir}";
      documents = "${documentsDir}";
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
