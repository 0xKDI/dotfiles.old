{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.term = "xterm-256color";
      window = {
        padding = {
          x = 1;
          y = 0;
        };
        dynamic_padding = true;
      };
      font = {
        normal.family = "JetBrains Mono nerd font";
        italic.style = "normal";
        size = 8.0;
      };
      colors = {
        primary = {
          background = "#1e2029";
          foreground = "#f8f8f2";
          dim_foreground = "0x9a9a9a";
          bright_foreground = "0xffffff";
        };
        normal = {
          black = "#000000";
          red = "#ff5555";
          green = "#50fa7b";
          yellow = "#f1fa8c";
          blue = "#caa9fa";
          magenta = "#ff79c6";
          cyan = "#8be9fd";
          white = "#bfbfbf";
        };
        bright = {
          black = "#343871";
          red = "#a6a631";
          green = "#767691";
          yellow = "#ffc573";
          blue = "#5f9ed6";
          magenta = "#e68559";
          cyan = "#65ddff";
          white = "#dfd4ca";
        };
      };
      background_opacity = 0.95;
      selection.save_to_clipboard = false;
      mouse.hide_when_typing = true;
    };
  };
}
