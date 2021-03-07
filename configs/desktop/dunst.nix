{ config, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "0x5-30+50";
        indicate_hidden = "yes";
        shrink = "no";
        transparency = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 16;
        horizontal_padding = 16;
        frame_width = 2;
        frame_color = "#bd93f9";
        separator_color = "frame";
        sort = "yes";
        font = "JetBrains 12";
        idle_threshold = 120;
        line_height = 2;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = "yes";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        sticky_history = "yes";
        history_length = 20;
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        history = "ctrl+grave";
        context = "ctrl+shift+period";

      };
      urgency_low = {
        background = "#1E2029";
        foreground = "#f8f8f2";
        timeout = 10;
      };
      urgency_normal = {
        background = "#282a36";
        foreground = "#f8f8f2";
        timeout = 10;
      };
      urgency_critical = {
        background = "#ff5555";
        foreground = "#282a36";
        timeout = 0;
      };
    };
  };
}
