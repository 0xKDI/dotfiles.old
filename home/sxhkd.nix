{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    xkb-switch
    pamixer
    maim
  ];


  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + F6" = "${config.dots.binDir}/toggle_mute";

    # volume keys
    "super + F3" = "${config.dots.binDir}/change_volume -i 5";
    "super + F2" = "${config.dots.binDir}/change_volume -d 5";
    "super + F1" = "${config.dots.binDir}/change_volume -t";
    "XF86AudioRaiseVolume" = "${config.dots.binDir}/change_volume -i 5";
    "XF86AudioLowerVolume" = "${config.dots.binDir}/change_volume -d 5";
    "XF86AudioMute" = "${config.dots.binDir}/change_volume -t";

    # switch layout
    "super + a" = "${pkgs.xkb-switch}/bin/xkb-switch -n";

    # backlight
    "super + F4" = "${config.dots.binDir}/change_brightness 5%-";
    "super + F5" = "${config.dots.binDir}/change_brightness +5%";
    "XF86MonBrightnessUp" = "${config.dots.binDir}/change_brightness 5%-";
    "XF86MonBrightnessDown" = "${config.dots.binDir}/change_brightness +5%";

    # terminal
    "super + Return" = "${pkgs.xst}/bin/xst -e ${pkgs.tmux}/bin/tmux attach";
    "super + shift + Return" = "${pkgs.xst}/bin/xst";

    # program launcher
    "super + space" = "${pkgs.xst}/bin/xst -c fzfmenu -e ${config.dots.binDir}/fzfappmenu";
    # browser bookmarks
    "super + e" = "${pkgs.xst}/bin/xst -c fzfmenu -e ${config.dots.binDir}/fzfbuku";
    # clipboard manager
    "super + s" = "${pkgs.xst}/bin/xst -c clipmenu -e ${pkgs.clipmenu}/bin/clipmenu";

    # windowmenu
    "super + w" = "${pkgs.xst}/bin/xst -c fzfmenu -e ${config.dots.binDir}/fzfwindowmenu";

    # screenshot
    "super + F11" = ''
      ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png
    '';

    # make sxhkd reload its configuration files:
    "super + shift + r" = "pkill -USR1 -x sxhkd";

    # BSPWM

    # quit/restart bspwm
    "super + alt + {q,r}" = "bspc {quit,wm -r}";

    # close node
    "super+ q" = "bspc node -c";

    # kill node
    "super + shift + q" = "bspc node -k";

    # alternate between the tiled and monocle layout
    "super + m" = "bspc desktop -l next";

    # send the newest marked node to the newest preselected node
    "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";

    # swap the current node and the biggest node
    "super + g" = "bspc node -s biggest";

    # rotate node by 90 deg
    "super + r" = "bspc node -R 90";

    # STATE/FLAGS

    # set the window state
    "super + {t,shift + t,shift + s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";

    # set the node flags
    "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";

    # FOCUS/SWAP

    # focus the node in the given direction
    "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";

    # focus the node for the given path jump
    "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";

    # focus the next/previous node in the current desktop
    "super + {_,shift + }d" = "bspc node -f {next,prev}.local";

    # focus the next/previous desktop in the current monitor
    "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";

    # focus the desktop
    "super + Tab" = "bspc desktop -f last";

    # focus the older or newer node in the focus history
    "super + {o,i}" = ''
      bspc wm -h off; \
      bspc node {older,newer} -f; \
      bspc wm -h on
    '';

    # focus or send to the given desktop
    "super + {_,shift + }{1-9,0}" = ''bspc {desktop -f,node -d} "^{1-9,10}"'';

    # PRESELECT

    # preselect the direction
    "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";

    # preselect the ratio
    "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";

    # cancel the preselection for the focused node
    "super + ctrl + space" = "bspc node -p cancel";

    # cancel the preselection for the focused desktop
    "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";

    # MOVE/RESIZE

    # expand a window by moving one of its side outward
    "super + {Left,Down,Up,Right}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";

    # contract a window by moving one of its side inward
    "super + shift + {Left,Down,Up,Right}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";

    # move a floating window
    "super + ctrl + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
  };
};
}
