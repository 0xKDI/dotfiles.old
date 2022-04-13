{ config, pkgs, lib, ... }:

with lib;
let
  workDir = "${home}/wrk";
  booksDir = "${home}/bks";
  syncDir = "${home}/snc";
  downloadDir = "${home}/dl";
  picturesDir = "${home}/pic";
  videosDir = "${home}/vid";
  documentsDir = "${home}/dcs";

  wallpapers = ../wallpapers;
  binPath = ../bin;

  user = config.home.username;
  home = config.home.homeDirectory;
  uid = "1000";
  email = "0qqw0qqw@gmail.com";

  dataHome = config.xdg.dataHome;
  configHome = config.xdg.configHome;
  cacheHome = config.xdg.cacheHome;

  has = pkg: (any (_: _ == pkg) config.home.packages);
  hasTf = has pkgs.terraform;
in
{
  imports = [
    ../modules
  ];


  home = {
    packages = with pkgs; [
      tree
      coreutils
      pciutils
      file
      killall
      curl
      wget
      gnumake
      gdb
      gcc
      progress
      bind

      exa
      fd
      sd
      ripgrep
      scc
      tealdeer # faster tldr
      manix
      du-dust # du + rust
      yq-go # yaml processor

      cachix
      nixpkgs-fmt
      nixpkgs-review
      nixfmt

      lsof
      nmap
      openssl
      tcpdump
    ] ++ optionals config.services.sxhkd.enable [
      brightnessctl
      xkb-switch
      pamixer
      maim
      dunst # required for dunstify
      acpi
    ] ++ optionals config.programs.go.enable [
      gopls
    ] ++ optionals config.xsession.enable [
      xorg.xev
      xdo
      xsecurelock
      xclip
      xwallpaper # set wallpaper
    ] ++ optionals config.fonts.fontconfig.enable [
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
    file = { } // optionalAttrs hasTf {
      ".terraformrc".text = ''
        plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
      '';
    };
    sessionPath =
      let
        go = config.programs.go;
      in
      [ "${home}/.local/bin" ] ++ optionals go.enable [
        "${home}/${go.goPath}/bin"
      ] ++ [ "${binPath}" ];
    sessionVariables = {
      DOCKER_CONFIG = "${configHome}/docker";
      LIBVIRT_DEFAULT_URI= "qemu:///system";

      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";

      # NOTE: doesn't work, 
      # move .compose_cache out of $HOME
      XCOMPOSEFILE = "${configHome}/X11/xcompose";
      XCOMPOSECACHE = "${cacheHome}/X11/xcompose";
      # same with .xsession_errors
      USERXSESSION = "${cacheHome}/X11/xsession";
      USERXSESSIONRC = "${cacheHome}/X11/xsessionrc";
      ALTUSERXSESSION = "${cacheHome}/X11/Xsession";
      ERRFILE = "${cacheHome}/X11/xsession-errors";

      PARALLEL_HOME = "${configHome}/parallel";
      CUDA_CACHE_PATH = "${cacheHome}/nv";
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";

      # Ruby
      GEM_HOME = "${dataHome}/gem";
      GEM_SPEC_CACHE = "${cacheHome}/gem";
    } // optionalAttrs config.programs.fzf.enable {
      CM_LAUNCHER = "fzf";
      CM_HISTLENGTH = 150;
    } // optionalAttrs config.modules.neovim.enable {
      VISUAL = "nvim";
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      MANWIDTH = 999;
    } // optionalAttrs true {
      DDGR_COLORS = "oCdgxf"; # duckduckgo-cli colors
    } // optionalAttrs config.modules.aws.enable {
      AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${configHome}/aws/config";
    } // optionalAttrs config.modules.python.enable {
      IPYTHONDIR = "${configHome}/jupyter";
      PYTHONSTARTUP = "${configHome}/pythonrc.py";
      # PYTHONPATH = "${home}/.local/lib/python3.9/site-packages";
      JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
    };
  };


  modules = {
  };


  programs = {
    go = {
      goPath = ".local/share/go";
    };
    bat = {
      config = {
        theme = "Dracula";
      };
    };
    zoxide = {
      enableZshIntegration = true;
      options = [ "--cmd q" ];
    };
    fzf = {
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd -HL --type d --exclude .git";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--reverse"
        "--multi"
        "--info=inline"
        "--color=dark"
        "--color=fg:7,bg:-1,hl:#5fff87,fg+:15,bg+:-1,hl+:#ffaf5f"
        "--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7"
      ];
      fileWidgetCommand = "fd -H -t f";
      fileWidgetOptions = [
        "--preview='bat"
        "--style=numbers"
        "--color=always {}"
      ];
    };
    direnv = {
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    starship = {
      enableZshIntegration = true;
      settings = {
        scan_timeout = 10;
        add_newline = false;
        character = {
          success_symbol = "[➜ ](bold green)";
          error_symbol = "[➜ ](bold red)";
          vicmd_symbol = "[V ](bold green)";
        };
        line_break.disabled = true;
        python.python_binary = "python3";
        format = [
          "username"
          "hostname"
          "shlvl"
          "kubernetes"
          "directory"
          "git_branch"
          "git_commit"
          "git_state"
          "git_status"
          # "hg_branch"
          "docker_context"
          "package"
          "cmake"
          # "dart"
          # "dotnet"
          # "elixir"
          # "elm"
          # "erlang"
          "golang"
          "helm"
          "java"
          # "julia"
          # "nim"
          "nodejs"
          # "ocaml"
          # "perl"
          # "php"
          # "purescript"
          "python"
          # "ruby"
          # "rust"
          # "swift"
          "terraform"
          # "zig"
          "nix_shell"
          # "conda"
          # "memory_usage"
          "aws"
          "gcloud"
          "env_var"
          # "crystal"
          "cmd_duration"
          "custom"
          "line_break"
          "jobs"
          "time"
          "status"
          "character"
        ];
      };
    };
    alacritty = {
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
    # browserpass.browsers = [ "chrome" "chromium" ];
    git = {
      userEmail = email;
      userName = "Dmitry Kulikov";
      ignores = [
        "Session.vim"
        ".envrc"
        "__local__"
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
    mpv = {
      package = pkgs.mpv;
      config = {
        profile = "gpu-hq";
        scale = "ewa_lanczossharp";
        cscale = "ewa_lanczossharp";
        interpolation = true;
        tscale = "oversample";
        video-sync = "display-resample";

        hwdec = "vaapi-copy";
        hwdec-codecs = "all";

        save-position-on-quit = true;
      };
    };
    password-store = {
      package = pkgs.gopass;
      settings = {
        PASSWORD_STORE_DIR = "${home}/.password-store";
        GOPASS_NO_NOTIFY = "true";
      };
    };
    zathura = {
      options = {
        page-padding = 2;
        recolor = "false";

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
    zsh = {
      autocd = true;
      defaultKeymap = "viins";
      dotDir = ".config/zsh";
      history.path = "${config.xdg.cacheHome}/zsh/history";
      initExtra = ''
        autoload -Uz edit-command-line; zle -N edit-command-line
        bindkey '^ ' edit-command-line
        autoload -U +X bashcompinit && bashcompinit
      '' + optionalString config.programs.fzf.enable ''
        bindkey '\eq' fzf-cd-widget
        bindkey '\er' fzf-history-widget
      '' + optionalString hasTf ''
        complete -o nospace -C ${pkgs.terraform_0_14}/bin/terraform terraform
      '' + optionalString (has pkgs.pandoc) ''
        eval "$(pandoc --bash-completion)"
      '' + optionalString config.modules.aws.enable ''
        source ${pkgs.awscli2}/share/zsh/site-functions/aws_zsh_completer.sh
      '' + optionalString (has pkgs.minikube) ''
        eval $(minikube completion zsh)
      '' + optionalString (has pkgs.minishift) ''
        eval $(minishift completion zsh)
      '';
      # NOTE: These two are RIDICULOUSLY slow
      # + optionalString (has pkgs.kops) ''
      #   source <(kops completion zsh) # doesn't work with eval
      #   '';
      shellAliases = {
        ap = "ansible-playbook";
        av = "ansible-vault";
        a = "ansible";

        vg = "vagrant";
        vlt = "vault";

        k = "kubectl";
        ka = "kubectl apply";
        kg = "kubectl get";
        kd = "kubectl describe";
        ke = "kubectl explain";
        kdl = "kubectl delete";

        d = "docker";
        dl = "docker logs -f --tail 1000";
        dc = "docker compose";
        dcl = "docker compose logs -f --tail 1000";

        tf = "terraform";

        rr = "rm -rf";

        mkdir = "mkdir -p";

        "2." = "cd ../..";
        "3." = "cd ../../..";
        "4." = "cd ../../../..";
        "5." = "cd ../../../../..";
        Q = "cd ~ ; clear";

        se = "sudoedit";

        ssh = "TERM=xterm ssh";

        start = "sudo systemctl start";
        stop = "sudo systemctl stop";
        restart = "sudo systemctl restart";
        status = "sudo systemctl status";
        enable = "sudo systemctl enable";
        disable = "sudo systemctl disable";

        ustart = "systemctl --user start";
        ustop = "systemctl --user stop";
        urestart = "systemctl --user restart";
        ustatus = "systemctl --user status";
        uenable = "systemctl --user enable";
        udisable = "systemctl --user disable";
        mk = "make";
        t = "tmuxp";
        tl = "tmuxp load -a";
        tll = "tmuxp load -y";
        y = "xclip -selection c";
        p = "xclip -selection c -o";
        n = "noti";
        vim = "nvim";
        vi = "nvim";
        v = "nvim";
        fs = "f -S";
        py3 = "python3";
        py2 = "python2";
        py = "python3";
        sxiv = "sxiv -b";
        qr = ''
          xclip -selection c -o |
          qrencode -o /tmp/grencode.png;
          devour sxiv -b /tmp/grencode.png
        '';
        g = "git";
        gs = "git status";
        c = "git commit -m";
        zt = "devour zathura";
        dst = "dust -r";
        s = "ddgr";
        trr = "transmission-remote";
        l = "exa -al --group-directories-first -g";
        ll = "exa -a --group-directories-first -g";
        lt = "exa -a --tree --group-directories-first -g -I .git";
        pass = "gopass";
      };
      plugins = with pkgs; [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-completions";
          src = "${pkgs.zsh-completions}/share/zsh/site-functions";
        }
        {
          name = "zsh-autopair";
          src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair";
          file = "autopair.zsh";
        }
      ] ++ optionals config.programs.fzf.enable [{
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }] ++ optionals config.xsession.enable [{
        name = "zsh-system-clipboard";
        src = "${pkgs.zsh-system-clipboard}/share/zsh/zsh-system-clipboard";
        file = "zsh-system-clipboard.zsh";
      }];
    };
  };


  services = {
    screen-locker = {
      lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
      inactiveInterval = 10;
      xautolock.extraOptions = [
        "-notifier"
        "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
      ];
    };
    sxhkd = {
      keybindings = let
        bin = binPath;
        xst = "${pkgs.xst}/bin/xst";
        tmux = "${pkgs.tmux}/bin/tmux";
        xkb-switch = "${pkgs.xkb-switch}/bin/xkb-switch";
      in
      {
        "super + Return" = "${xst} -e ${tmux} attach";
        "super + shift + Return" = xst;
        "super + space" = "${bin}/fzfappmenu";
        "super + s" = "${bin}/fzfclipmenu";
        "super + w" = "${bin}/swap_desktops";
        "super + e" = "${bin}/fzfwindowmenu";
        "super + Home" = "${bin}/fzfbooks";
        "super + F11" = "${bin}/screenshot";
      } // {
        "super + z" = "vlock & xset s activate";
        "super + Z" = "vlock & systemctl suspend";
        "super + F6" = "${bin}/toggle_mute";
        "super + F3" = "${bin}/change_volume -i 5";
        "super + F2" = "${bin}/change_volume -d 5";
        "super + F1" = "${bin}/change_volume -t";
        "XF86AudioRaiseVolume" = "${bin}/change_volume -i 5";
        "XF86AudioLowerVolume" = "${bin}/change_volume -d 5";
        "XF86AudioMute" = "${bin}/change_volume -t";
        "super + a" = "${xkb-switch} -n";
        "super + F4" = "${bin}/change_brightness 5%-";
        "super + F5" = "${bin}/change_brightness +5%";
        "XF86MonBrightnessUp" = "${bin}/change_brightness 5%-";
        "XF86MonBrightnessDown" = "${bin}/change_brightness +5%";
        # make sxhkd reload its configuration files:
        "super + shift + r" = "pkill -USR1 -x sxhkd";
      } // {
        # BSPWM/general
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
      } // {
        # BSPWM/state
        # set the window state
        "super + {t,shift + t,shift + f,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        # set the node flags
        "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";
      } // {
        # BSPWM/focus
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
      } // {
        # BSPWM/preselect
        # preselect the direction
        "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
        # preselect the ratio
        "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
        # cancel the preselection for the focused node
        "super + ctrl + space" = "bspc node -p cancel";
        # cancel the preselection for the focused desktop
        "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
      } // {
        # BSPWM/resize
        # expand a window by moving one of its side outward
        "super + {Left,Down,Up,Right}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
        # contract a window by moving one of its side inward
        "super + shift + {Left,Down,Up,Right}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
        # move a floating window
        "super + ctrl + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      };
    };
    gpg-agent = {
      enableSshSupport = true;
      defaultCacheTtl = 60480000;
      defaultCacheTtlSsh = 60480000;
      maxCacheTtl = 60480000;
      maxCacheTtlSsh = 60480000;
    };
    udiskie = {
      automount = true;
      notify = true;
      tray = "never";
    };
    dunst.settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "=0x5-0+0";
        max_icon_size = 30;
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
        font = "FiraCode Bold 14";
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
    polybar = {
        script = ''
          polybar eDP-1 &
          polybar HDMI-1 &
        '';
        package = pkgs.polybar.override {
          pulseSupport = true;
          nlSupport = true;
        };
        config = {
          "global/wm" = {
            margin-top = 0;
            margin-bottom = 0;
          };
          "settings" = {
            throttle-output = 5;
            throttle-output-for = 10;
            screenchange-reload = true;
            compositing-background = "over";
            compositing-foreground = "over";
            compositing-overline = "over";
            compositing-underline = "over";
            compositing-border = "over";
          };
          "bar/base" = {
            width = "100%";
            bottom = false;
            height = 30;
            fixed-center = false;
            background = "#1e2029";
            foreground = "#bd93f9";
            line-size = 2;
            padding-right = 1;
            module-margin-left = 1;
            module-margin-right = 1;
            font-0 = "FantasqueSansMono nerd font:style=Bold:size=12;3";
            modules-left = "bspwm";
            modules-center = "xwindow";
            modules-right = "wlan backlight pulseaudio xkeyboard memory cpu battery date";
            tray-position = "left";
            tray-padding = 0;
            tray-background = "#1e2029";
            cursor-click = "pointer";
            cursor-scroll = "ns-resize";
            wm-restack = "bspwm";
          };
          "bar/eDP-1" = {
            "inherit" = "bar/base";
            monitor = "eDP-1";
          };
          "bar/HDMI-1" = {
            "inherit" = "bar/base";
            monitor = "HDMI-1";
          };
          "module/bspwm" = {
            type = "internal/bspwm";
            format = "<label-state>";
            format-margin = 1;
            format-foreground = "#50fa7b";

            label-padding = 1;

            label-focused = "%name%";
            label-focused-foreground = "#ff79c6";
            label-focused-underline = "#fba922";
            label-focused-padding = 1;

            label-occupied = "%name%";
            label-occupied-foreground = "#ff79c6";
            label-occupied-padding = 1;

            label-empty = "%name%";
            label-empty-foreground = "#6272a4";
            label-empty-padding = 1;

            label-urgent = "%name%";
            label-urgent-foreground = "#ff5555";
            label-urgent-padding = 1;

            label-monocle = "M ";
            label-tiled = " ";
            label-fullscreen = " ";
            label-floating = " ";
            label-pseudotiled = "  ";
            label-locked = "  ";
            label-locked-foreground = "#bd2c40";
            label-sticky = "  ";
            label-sticky-foreground = "#fba922";
            label-private = "  ";
            label-private-foreground = "#bd2c40";
            label-marked = "  ";
          };
          "module/xwindow" = {
            type = "internal/xwindow";
            label = "%title:0:80:...%";
            label-foreground = "#ffb86c";
            label-padding = 1;
          };
          "module/mpd" = {
            type = "internal/mpd";
            format-online = "<label-song> <label-time>";
            format-online-prefix-foreground = "#bd93f9";
            label-song = "%title% - %artist%";
            label-song-foreground = "#ffb86c";
            label-time = "(%elapsed%/%total%)";
            label-time-foreground = "#6272a4";
          };
          "module/wlan" = {
            type = "internal/network";
            interface = "wlp2s0";
            interval = "1.0";
            format-connected = " ";
            format-disconnected = "";
          };
          "module/backlight" = {
            type = "internal/backlight";
            card = "intel_backlight";
            enable-scroll = true;
            format = "<label>";
            label = " %percentage%%";
          };
          "module/xbacklight" = {
            type = "internal/xbacklight";
            format = "<label>";
            label = " %percentage%%";
          };
          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            label-volume = "墳 %percentage%%";
            label-muted = "婢 muted";
          };
          "module/xkeyboard" = {
            type = "internal/xkeyboard";
            format = "<label-layout>";
            label-layout = " %layout%";
          };
          "module/memory" = {
            type = "internal/memory";
            interval = 1;
            format-prefix = "[   ";
            label = "%gb_used%]";
          };
          "module/cpu" = {
            type = "internal/cpu";
            interval = 1;
            format-prefix = "[   ";
            label = "%percentage:2%%]";
          };
          "module/filesystem" = {
            type = "internal/fs";
            interval = 25;
            mount-0 = "/";
            label-mounted = "  %percentage_used%%";
            label-unmounted = "%mountpoint% not mounted";
          };
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "ADP0";
            full-at = "98";
            format-discharging = "<ramp-capacity> <label-discharging>";
            label-discharging = "%percentage%%";
            ramp-capacity-0 = " ";
            ramp-capacity-0-foreground = "#ff5555";
            ramp-capacity-1 = " ";
            ramp-capacity-1-foreground = "#ffb86c";
            ramp-capacity-2 = " ";
            ramp-capacity-3 = " ";
            ramp-capacity-4 = " ";
            format-charging-prefix = " ";
            format-charging = "<animation-charging> <label-charging>";
            format-charging-foreground = "#f1fa8c";
            label-charging = "\${self.label-discharging}";
            animation-charging-0 = " ";
            animation-charging-1 = " ";
            animation-charging-2 = " ";
            animation-charging-3 = " ";
            animation-charging-4 = " ";
            animation-charging-foreground = "#f1fa8c";
            animation-charging-framerate = 750;

            format-full-prefix = " ";
            format-full = "<ramp-capacity>  <label-full>";
            format-full-foreground = "#50fa7b";
            label-full = "\${self.label-discharging}";
          };
          "module/date" = {
            type = "internal/date";
            interval = 1;
            date = "%a, %d %b";
            date-alt = "%Y-%m-%d";
            time = "%I:%M %p";
            time-alt = "%H:%M:%S";
            label = "%date% %time%";
          };
        };
      };
  };


  gtk = {
    gtk3.bookmarks = [
      "file://${workDir}"
      "file://${booksDir}"
      "file://${syncDir}"
    ];
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };


  xdg = {
    userDirs = {
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
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/jpeg" = "sxiv.desktop";
        "image/png" = "sxiv.desktop";
      };
    };
    configFile = {
      "npm/npmrc".text = ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        tmp=''${XDG_RUNTIME_DIR}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      '';
      "nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
      "nix/nix.conf".text = ''
        experimental-features = nix-command flakes ca-references
        substituters = https://cache.nixos.org https://nix-community.cachix.org
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      '';
    } // optionalAttrs config.modules.python.enable {
      "pythonrc.py".text = ''
        #!/usr/bin/env python3

        import atexit
        import os
        import readline

        histfile = os.path.join(os.path.expanduser("~"), ".local/share/python_history")
        try:
            readline.read_history_file(histfile)
            readline.set_history_length(1000)
        except FileNotFoundError:
            pass

        atexit.register(readline.write_history_file, histfile)
      '';
    };
  };


  xsession = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      size = 20;
      name = "capitaine-cursors";
    };
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
      ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${wallpapers}/nix-wallpaper-dracula.png &
      xset s 300 5 &
      xset r rate 250 60 &
    '';
    windowManager.bspwm = {
      monitors = {
        "eDP-1" = [ "1" "2" "3" "4" "5" ];
        "HDMI-1" = [ "6" "7" "8" "9" "0" ];
      };
      extraConfig = ''
        bspc wm -O eDP-1 HDMI-1
        bspc config pointer_follows_focus true
      '';
      startupPrograms = [
        "xrandr --output DVI-I-1-1 --auto"
        # https://github.com/nix-community/home-manager/issues/195
        "systemctl --user restart polybar.service"
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
        "brave".desktop = "^1";
        "Skype".desktop = "^5";
        "TelegramDesktop" = {
          desktop = "^5";
          state = "tiled";
        };
        "Spotify".desktop = "^4";
        "Zathura".state = "tiled";
        "fzfmenu".state = "floating";
        "clipmenu".state = "floating";
        "nvimedit".state = "floating";
        "draw.io".desktop = "^3";
      };
    };
  };


  xresources.properties = {
    "*.foreground" = "#F8F8F2";
    "*.background" = "#1E2029";
    "*.color0" = "#000000";
    "*.color8" = "#4D4D4D";
    "*.color1" = "#FF5555";
    "*.color9" = "#FF6E67";
    "*.color2" = "#50FA7B";
    "*.color10" = "#5AF78E";
    "*.color3" = "#F1FA8C";
    "*.color11" = "#F4F99D";
    "*.color4" = "#BD93F9";
    "*.color12" = "#CAA9FA";
    "*.color5" = "#FF79C6";
    "*.color13" = "#FF92D0";
    "*.color6" = "#8BE9FD";
    "*.color14" = "#9AEDFE";
    "*.color7" = "#BFBFBF";
    "*.color15" = "#E6E6E6";
    "st.font" = "FantasqueSansMono nerd font:pixelsize=20:antialias=true:autohint=true";
    "st.disableitalics" = 1;
    "st.disableroman" = 1;
    "st.termname" = "st-256color";
    "st.cursorfg" = "#ffb86c";
  };
}
