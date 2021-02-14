{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    xwallpaper # set wallpaper

    xorg.xev
    xdo
    xsecurelock
    xclip
  ];


  xsession = {
    enable = true;
    scriptPath = ".xsession";
    importedVariables = [
      "PATH"
      # nessesary for fzf
      "CM_LAUNCHER"
      "FZF_DEFAULT_OPTS"
      "CM_HISTLENGTH"
    ];
    initExtra = ''
      rm -drf ~/.xsession-errors ~/.xsession-errors.old ~/.compose_cache
      ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${config.dots.confDir}/wallpaper &
      xset r rate 250 60
    '';
  };


  xsession.windowManager.bspwm = {
    enable = true;
    monitors = { "eDP1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]; };
    startupPrograms = [
      # https://github.com/nix-community/home-manager/issues/195
      "systemctl --user restart polybar"
    ];
    settings = {
      border_width = 2;
      window_gap = 0;

      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      single_monocle = true;

      split_ratio = 0.50;
      automatic_scheme = "spiral";
      initial_polarity = "second_child";
      borderless_monocle = true;
      gapless_monocle = true;

      focus_follows_pointer = true;

      remove_disabled_monitors = true;
      merge_overlapping_monitors = true;
      ignore_ewmh_fullscreen = "all";
      ignore_ewmh_focus = true;

      pointer_modifier = "mod4";
      pointer_action1 = "move";
      pointer_action2 = "resize_side";
      pointer_action3 = "resize_corner";

      normal_border_color = "#282a36";
      active_border_color = "#bd93f9";
      focused_border_color = "#bd93f9";
      presel_feedback_color = "#6272a4";
    };
    rules = {
      "firefox".desktop = "^1";
      "Firefox".desktop = "^1";
      "TelegramDesktop".state = "floating";
      "Spotify".desktop = "^9";
      "Zathura".state = "tiled";
      "fzfmenu".state = "floating";
      "clipmenu".state = "floating";
      "nvimedit".state = "floating";
      "draw.io".desktop = "^3";
    };
  };
}
