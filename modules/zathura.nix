{ config, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
    options = {
      page-padding = 2;
      recolor = "true";

      completion-bg = "#282a36";
      completion-fg = "#f8f8f2";
      completion-group-bg = "#282a36";
      completion-group-fg = "#ff79c6";
      completion-highlight-bg = "#f8f8f2";
      completion-highlight-fg = "#282a36";

      recolor-lightcolor = "rgba(40,42,54,0.8)";
      recolor-darkcolor = "#f8f8f2";
      default-bg = "rgba(40,42,54,1.0)";
      recolor-reverse-video = "true";

      inputbar-bg = "rgba(40,42,54,0)";
      inputbar-fg = "#f8f8f2";
      notification-bg = "#282a36";
      notification-fg = "#f8f8f2";
      notification-error-bg = "#ff5555";
      notification-error-fg = "#f8f8f2";
      notification-warning-bg = "#ff5555";
      notification-warning-fg = "#f8f8f2";
      statusbar-bg = "rgba(40,42,54,0)";
      statusbar-fg = "#ffb86c";
      index-bg = "rgba(40,42,54,0)";
      index-fg = "#f8f8f2";
      index-active-bg = "#f8f8f2";
      index-active-fg = "#282a36";
      render-loading-bg = "#282a36";
      render-loading-fg = "#dfd4ca";

      window-title-home-tilde = "true";
      statusbar-basename = "true";
      guioptions = "";
      font = "Noto Sans Bold 10";

      selection-clipboard = "clipboard";
      zoom-center = "true";
      show-hidden = "true";
    };
  };
}
