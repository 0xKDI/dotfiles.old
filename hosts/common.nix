{ config, pkgs, lib, ... }:

with lib;
let
  univercityDir = "${home}/uni";
  projectDir = "${home}/prj";
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
  hasTf = has pkgs.terraform_0_15;
in
{
  imports = [
    ../modules
  ];


  home = {
    packages = with pkgs; [
      coreutils
      file
      killall
      curl
      wget
      gnumake
      gdb
      gcc
      progress

      exa
      fd
      sd
      ripgrep
      scc
      tealdeer # faster tldr
      manix
      du-dust # du + rust

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
    ] ++ optionals config.programs.firefox.enable [
      tridactyl-native
      buku
      sqlite # required for buku
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
    file = { } // optionalAttrs config.programs.firefox.enable
      {
        ".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
        ".local/share/tridactyl/native_main.py".source = "${pkgs.tridactyl-native}/share/tridactyl/native_main.py";
      } // optionalAttrs hasTf {
      ".terraformrc".text = ''
        plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
      '';
    };
    sessionPath =
      let
        go = config.programs.go;
      in
      [ "${binPath}" "${home}/.local/bin" ] ++ optionals go.enable [
        "${home}/${go.goPath}/bin"
      ];
    sessionVariables = {
      DOCKER_CONFIG = "${configHome}/docker";

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
    } // optionalAttrs config.modules.latex.enable {
      TEXMFHOME = "${dataHome}/texmf";
      TEXMFVAR = "${cacheHome}/texlive/texmf-var";
      TEXMFCONFIG = "${configHome}/texlive/texmf-config";
    } // optionalAttrs config.modules.aws.enable {
      AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${configHome}/aws/config";
    } // optionalAttrs config.modules.python.enable {
      IPYTHONDIR = "${configHome}/jupyter";
      PYTHONSTARTUP = "${configHome}/pythonrc.py";
      PYTHONPATH = "${home}/.local/lib/python3.9/site-packages";
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
      enableNixDirenvIntegration = true;
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
          # "java"
          # "julia"
          # "nim"
          # "nodejs"
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
    firefox = {
      package = pkgs.firefox-bin;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        stylus
        ublock-origin
        tridactyl
        browserpass
      ];
      profiles.${user} = {
        name = "${user}";
        isDefault = true;
        userContent = ''
          :root{ scrollbar-width: none !important } 
        '';
        settings = {
          "devtools.theme" = "dark";
          "browser.downloadir" = "${home}/dl";
          # bad
          "general.smoothScroll" = false;

          # Enable userContent.css and userChrome.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # annoying
          "browser.tabs.warnOnClose" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.aboutwelcome.enabled" = false;

          # search
          "browser.search.region" = "US";
          "browser.search.geoSpecificDefaults" = false;
          "browser.urlbar.suggest.searches" = false;

          # Hardware video acceleration
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          # Enable OpenGL compositor
          "layers.acceleration.force-enabled" = true;
          # Enable WebRender compositor
          "gfx.webrender.all" = true;

          # Move disk cache to RAM
          "browser.cache.disk.parent_directory" = "/run/user/${uid}/firefox";

          # Disable pocket
          "extensions.pocket.enabled" = false;

          # tnx, no
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = false;
          "browser.ping-centre.telemetry" = false;
          "dom.security.unexpected_system_load_telemetry_enabled" = false;
          "security.app_menu.recordEventTelemetry" = false;
          "security.certerrors.recordEventTelemetry" = false;
          "security.identitypopup.recordEventTelemetry" = false;
          "security.protectionspopup.recordEventTelemetry" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "full-screen-api.ignore-widgets" = true;
        };
      };
    };
    browserpass.browsers = [ "firefox" ];
    git = {
      userEmail = email;
      userName = "Dmitry Kulikov";
      ignores = [
        "Session.vim"
        ".envrc"
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
      };
    };
    zathura = {
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
      '';
      # NOTE: These two are RIDICULOUSLY slow
      # + optionalString (has pkgs.minikube) ''
      # eval $(minikube completion zsh)
      # '';
      # + optionalString (has pkgs.kops) ''
      #   source <(kops completion zsh) # doesn't work with eval
      #   '';
      shellAliases = {
        d = "docker";
        dc = "docker-compose";

        mkdir = "mkdir -p";

        "2." = "cd ../..";
        "3." = "cd ../../..";
        "4." = "cd ../../../..";
        "5." = "cd ../../../../..";
        Q = "cd ~ ; clear";
      } // optionalAttrs (has pkgs.gnumake) {
        mk = "make";
      } // optionalAttrs config.programs.tmux.tmuxp.enable {
        t = "tmuxp";
        tl = "tmuxp load -a";
        tll = "tmuxp load -y";
      } // optionalAttrs config.xsession.enable {
        y = "xclip -selection c";
        p = "xclip -selection c -o";
      } // optionalAttrs config.programs.noti.enable {
        n = "noti";
      } // optionalAttrs hasTf {
        tf = "terraform";
      } // optionalAttrs config.modules.neovim.enable {
        vim = "nvim";
        vi = "nvim";
        v = "nvim";
        fs = "f -S";
      } // optionalAttrs config.modules.python.enable {
        py3 = "python3";
        py2 = "python2";
        py = "python3";
      } // optionalAttrs (config.systemd.user.startServices == "legacy") {
        se = "sudoedit";

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
      } // optionalAttrs config.programs.firefox.enable {
        b = "buku --suggest";
      } // optionalAttrs config.modules.sxiv.enable {
        sxiv = "sxiv -b";
        qr = ''
          xclip -selection c -o |
          qrencode -o /tmp/grencode.png;
          devour sxiv -b /tmp/grencode.png
        '';
      } // optionalAttrs config.programs.git.enable {
        g = "git";
        gs = "git status";
        c = "git commit -m";
      } // optionalAttrs config.programs.zathura.enable {
        zt = "devour zathura";
      } // optionalAttrs (has pkgs.kubectl) {
        k = "kubectl";
        ka = "kubectl apply";
        kg = "kubectl get";
        kd = "kubectl describe";
        ke = "kubectl explain";
        kdl = "kubectl delete";
      } // optionalAttrs (has pkgs.du-dust) {
        dst = "dust -r";
      } // optionalAttrs (has pkgs.ddgr) {
        s = "ddgr";
      } // optionalAttrs (has pkgs.transmission) {
        trr = "transmission-remote";
      } // optionalAttrs (has pkgs.exa) {
        l = "exa -al --group-directories-first -g";
        ll = "exa -a --group-directories-first -g";
        lt = "exa -a --tree --group-directories-first -g -I .git";
      }// optionalAttrs config.programs.password-store.enable {
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
      lockCmd = "systemctl suspend";
      inactiveInterval = 15;
      xssLockExtraOptions = [
        "-n"
        "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
        "-l"
        "--"
        "${pkgs.xsecurelock}/bin/xsecurelock"
      ];
    };
    sxhkd = {
      keybindings = let
        bin = binPath;
      in
      {
        "super + Return" = "${pkgs.xst}/bin/xst -e ${pkgs.tmux}/bin/tmux attach";
        "super + shift + Return" = "${pkgs.xst}/bin/xst";
        "super + space" = "${bin}/fzfappmenu";
        "super + e" = "${bin}/fzfbuku";
        "super + s" = "${bin}/fzfclipmenu";
        "super + w" = "${bin}/fzfwindowmenu";
        "super + Home" = "${bin}/fzfbooks";
        "super + F11" = "${bin}/screenshot";
      } // {
        "super + z" = "xset s activate";
        "super + F6" = "${bin}/toggle_mute";
        "super + F3" = "${bin}/change_volume -i 5";
        "super + F2" = "${bin}/change_volume -d 5";
        "super + F1" = "${bin}/change_volume -t";
        "XF86AudioRaiseVolume" = "${bin}/change_volume -i 5";
        "XF86AudioLowerVolume" = "${bin}/change_volume -d 5";
        "XF86AudioMute" = "${bin}/change_volume -t";
        "super + a" = "${pkgs.xkb-switch}/bin/xkb-switch -n";
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
        "super + {t,shift + t,shift + s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
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
      defaultCacheTtl = 28800;
      defaultCacheTtlSsh = 28800;
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
        geometry = "0x5-30+50";
        max_icon_size = 25;
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
    polybar =
      let
        barname = "main";
      in
      {
        script = "polybar ${barname} &";
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
          "bar/${barname}" = {
            monitor = "\${env:MONITOR:eDP1}";
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
          "module/bspwm" = {
            type = "internal/bspwm";
            format = "<label-state>";
            format-margin = 1;
            format-foreground = "#50fa7b";

            label-padding = 1;
            ws-icon-0 = "1; ";
            ws-icon-1 = "2; ";
            ws-icon-2 = "3; ";
            ws-icon-3 = "4; ";
            ws-icon-4 = "5; ";
            ws-icon-5 = "6; ";
            ws-icon-6 = "7; ";
            ws-icon-7 = "8; ";
            ws-icon-8 = "9; ";

            label-focused = "%icon%";
            label-focused-foreground = "#ff79c6";
            label-focused-underline = "#fba922";
            label-focused-padding = 1;

            label-occupied = "%icon%";
            label-occupied-foreground = "#ff79c6";
            label-occupied-padding = 1;

            label-empty = "%icon%";
            label-empty-foreground = "#6272a4";
            label-empty-padding = 1;

            label-urgent = "%icon%";
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
    } // optionalAttrs config.programs.firefox.enable {
      "tridactyl/tridactylrc".text = ''
        colourscheme quakelight
        sanitise tridactyllocal tridactylsync
        bind j scrollline 4
        bind k scrollline -4
        bind : fillcmdline_notrail
        bind YU hint -y
        bind ,l fillcmdline_notrail tabopen http://localhost:
        bind ,g fillcmdline_notrail tabopen https://github.com/
        bind ,s tabopen https://github.com/detailyang/awesome-cheatsheet
        set scrollduration 20
        set allowautofocus false
        set keytranslatemap {"о":"j", "л":"k"}
        set editorcmd ${pkgs.xst}/bin/xst -c nvimedit -e ${pkgs.neovim-nightly}/bin/nvim %f "+normal!%lGzv%c|"

        " C-c C-p
        " make d take you to the tab you were just on (I find it much less confusing)
        bind d composite tab #; tabclose #
        bind D tabclose
        " Stupid workaround to let hint -; be used with composite which steals semi-colons
        command hint_focus hint -;
        bind ;C composite hint_focus; !s xdotool key Menu
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
      xset r rate 250 60 &
      xset s 300 10
    '';
    windowManager.bspwm = {
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
        "Firefox".desktop = "^1";
        "Skype".desktop = "^9";
        "TelegramDesktop" = {
          desktop = "^9";
          state = "tiled";
        };
        "Spotify".desktop = "^8";
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


  systemd.user = {
    services."check_battery" = {
      Unit = {
        Description = "check_battery";
      };
      Service = {
        Environment = ''
          "PATH=${pkgs.libnotify}/bin:
          ${pkgs.acpi}/bin:
          ${pkgs.coreutils}/bin:
          ${pkgs.gnugrep}/bin"
        '';
        ExecStart = "${binPath}/check_battery";
      };
    };
    timers."check_battery" = {
      Unit = {
        Description = "Timer to check battery status";
      };
      Timer = {
        OnActiveSec = "5min";
        OnUnitActiveSec = "5min";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
