{ config, pkgs, ... }:

{

  imports = [
    ./options.nix
  ];


  xdg.configFile."nixpkgs/config.nix".text = ''
    {
     allowUnfree = true; 
    }
  '';


  home.packages = with pkgs; [
    aws
    cachix
    python3

    tdesktop

    texlive.combined.scheme-full
    python38Packages.pygments
    corefonts # Microsoft fonts

    mpvc # a mpc-like control interface for mpv
    youtube-dl
    libreoffice-fresh
    hunspellDicts.ru-ru
    gimp
    imagemagick
    sxiv

    # TODO: add spicetify-cli
    # https://github.com/khanhas/spicetify-cli
    spotifywm
    xst

    # for firefox
    tridactyl-native
    buku

    syncthing-cli #stcli

    qrencode # for QR-code

    acpi

    # essential
    gnumake
    coreutils
    killall
    curl
    wget

    file
    tree
    exa
    fd
    ripgrep
    tealdeer # faster tldr
    manix

    # for scripts
    dunst
    brightnessctl
    xkb-switch
    pamixer
    maim
    xwallpaper # set wallpaper

    # archive
    unrar
    p7zip

    # X11
    xorg.xev
    xdo
    xsecurelock
    xclip
  ];

  programs.home-manager.enable = true;

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
  };

  xsession.windowManager.bspwm = {
    enable = true;
    monitors = { "eDP-1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]; };
    startupPrograms = [
      "xset r rate 250 60"
    ];
  };

  xsession.windowManager.bspwm.settings = {
    border_width = 2;
    window_gap   = 0;

    top_padding    = 0;
    bottom_padding = 0;
    left_padding   = 0;
    right_padding  = 0;
    single_monocle     = true;

    split_ratio        = 0.50;
    automatic_scheme   = "spiral";
    initial_polarity   = "second_child";
    borderless_monocle = true;
    gapless_monocle    = true;

    focus_follows_pointer      = true;

    remove_disabled_monitors   = true;
    merge_overlapping_monitors = true;
    ignore_ewmh_fullscreen     = "all";
    ignore_ewmh_focus          = true;

    pointer_modifier = "mod4";
    pointer_action1 = "move";
    pointer_action2 = "resize_side";
    pointer_action3 = "resize_corner";

    normal_border_color = "#282a36";
    active_border_color = "#bd93f9";
    focused_border_color = "#bd93f9";
    presel_feedback_color = "#6272a4";
  };

  xsession.windowManager.bspwm = {
    rules = {
      "firefox" = {
        desktop = "^1";
      };
      "Firefox" = {
        desktop = "^1";
      };
      "TelegramDesktop" = {
        state = "floating";
      };
      "Spotify" = {
        desktop = "^9";
      };
      "Zathura" = {
        state = "tiled";
      };
      "fzfmenu" = {
        state = "floating";
      };
      "clipmenu" = {
        state = "floating";
      };
    };
  };

  services.sxhkd.enable = true;
  services.sxhkd.keybindings = { 
    # volume keys
    "super + F3" = "${config.dots.binDir}/change_volume -i 5";
    "super + F2" = "${config.dots.binDir}/change_volume -d 5";
    "super + F1" = "${config.dots.binDir}/change_volume -t";

    # switch layout
    "super + a"  = "${pkgs.xkb-switch}/bin/xkb-switch -n";

    # backlight
    "super + F4" = "${config.dots.binDir}/change_brightness 5%-";
    "super + F5" = "${config.dots.binDir}/change_brightness +5%";

    # terminal
    "super + Return"         = "${pkgs.xst}/bin/xst -e ${pkgs.tmux}/bin/tmux attach";
    "super + shift + Return" = "${pkgs.xst}/bin/xst";

    # program launcher
    "super + space" = "${pkgs.xst}/bin/xst -c fzfmenu -e ${config.dots.binDir}/fzfappmenu";
    # browser bookmarks
    "super + e"     = "${pkgs.xst}/bin/xst -c fzfmenu -e ${config.dots.binDir}/fzfbuku";
    # clipboard manager
    "super + s" = "${pkgs.xst}/bin/xst -c clipmenu -e ${pkgs.clipmenu}/bin/clipmenu";

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

    # focus the last node
    "super + w" = "${pkgs.xst}/bin/xst -c bookmarks -e ${config.dots.binDir}/fzfwindowmenu";

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

  services.polybar = {
    enable = true;
    script = "polybar main &";
    package = pkgs.polybar.override {
      pulseSupport = true;
      nlSupport = true;
    };
    config = "${config.dots.confDir}/polybar/config";
  };

  xsession.initExtra = ''
    rm ~/.xsession-errors ~/.xsession-errors.old
    ${pkgs.xwallpaper}/bin/xwallpaper --zoom ${config.dots.confDir}/wallpaper &
  '';

  home.sessionVariables = {
    # z-lua
    _ZL_CMD = "q";
    _ZL_DATA = "${config.xdg.dataHome}/zlua";

    # clipmenu
    CM_LAUNCHER = "fzf";
    CM_HISTLENGTH = 150;

    # editor
    VISUAL = "nvim";
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";

    MANPAGER = "nvim +Man!";
    MANWIDTH = 999;

    AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
    AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";


    # NOTE: doesn't work, 
    # move .compose_cache out of $HOME
    XCOMPOSEFILE = "${config.xdg.configHome}/x11/xcompose";
    XCOMPOSECACHE = "${config.xdg.cacheHome}x11/xcompose";
    # same with .xsession_errors
    USERXSESSION = "${config.xdg.cacheHome}/x11/xsession";
    USERXSESSIONRC = "${config.xdg.cacheHome}/x11/xsessionrc";
    ALTUSERXSESSION = "${config.xdg.cacheHome}/x11/Xsession";
    ERRFILE = "${config.xdg.cacheHome}/x11/xsession-errors";
    PARALLEL_HOME = "${config.xdg.configHome}/parallel";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    # Ruby
    GEM_HOME = "${config.xdg.dataHome}/gem";
    GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";

    # Jupiter/IPython
    IPYTHONDIR = "${config.xdg.configHome}/jupyter";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
  };


  fonts.fontconfig.enable = true;

  
  services.unclutter.enable = true; # hide cursor when it's not used

  xsession.pointerCursor = {
    package = pkgs.capitaine-cursors;
    size = 20;
    name = "capitaine-cursors";
  };


  gtk = {
    enable = true;
    gtk3.bookmarks = [
      "file:///home/${config.home.username}/uni"
      "file:///home/${config.home.username}/proj"
      "file:///home/${config.home.username}/bks"
    ];
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  # FIXME: Vbox doesn't care
  qt = {
    enable = true;
    platformTheme = "gtk";
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

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor              = 0;
        follow               = "mouse";
        geometry             = "0x5-30+50";
        indicate_hidden      = "yes";
        shrink               = "no";
        transparency         = 0;
        notification_height  = 0;
        separator_height     = 2;
        padding              = 16;
        horizontal_padding   = 16;
        frame_width          = 2;
        frame_color          = "#bd93f9";
        separator_color      = "frame";
        sort                 = "yes";
        font                 = "JetBrains 12";
        idle_threshold       = 120;
        line_height          = 2;
        markup               = "full";
        format               = "<b>%s</b>\\n%b";
        alignment            = "left";
        show_age_threshold   = 60;
        word_wrap            = "yes";
        ellipsize            = "middle";
        ignore_newline       = "no";
        stack_duplicates     = true;
        hide_duplicate_count = false;
        show_indicators      = "yes";
        sticky_history       = "yes";
        history_length       = 20;
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

  services.clipmenu.enable = true;

  systemd.user.startServices = true;

  systemd.user.services."check_battery" = {
    Unit = {
      Description = "check_battery";
    };
    Service = {
      Environment = ''
        "PATH=${pkgs.libnotify}/bin:
        ${pkgs.acpi}/bin:
        ${pkgs.coreutils}/bin:
        ${pkgs.gnugrep}/bin "
      '';
      ExecStart = "${config.dots.binDir}/check_battery";
    };
  };

  systemd.user.timers."check_battery" = {
    Unit = {
      Description="Timer to check battery status";
    };
    Timer = {
      OnActiveSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
  };


  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    history.path = "${config.xdg.cacheHome}/zsh/history";
    initExtra = ''
            bindkey '\eq' fzf-cd-widget
            bindkey '\er' fzf-history-widget
    '';
  };

  programs.zsh.shellAliases = {

    b = "buku --suggest";

    # general
    v = "nvim";

    # systemd
    se = "sudoedit";

    # systemlevel
    start = "sudo systemctl start";
    stop = "sudo systemctl stop";
    restart = "sudo systemctl restart";
    status = "sudo systemctl status";
    enable = "sudo systemctl enable";
    disable = "sudo systemctl disable";

    # userlevel
    ustart = "systemctl --user start";
    ustop = "systemctl --user stop";
    urestart = "systemctl --user restart";
    ustatus = "systemctl --user status";
    uenable = "systemctl --user enable";
    udisable = "systemctl --user disable";

    "..." = "cd ../..";
    "...." = "cd ../../..";
    Q = "cd ~ ; clear";

    sxiv = "devour sxiv -b";
    zathura= "devour zathura";

    # exa
    l = "exa -al --group-directories-first -s type -r";
    ll = "exa -a --group-directories-first -s type -r";
    lt = "exa -a --tree --group-directories-first -s type -r";
    L = "exa -l --group-directories-first -s type -r";

    # git
    g = "git";
    gs = "git status";

    y = "xclip -selection c";
    p = "xclip -selection c -o";
    qr = ''
      xclip -selection c -o |
      qrencode -o /tmp/grencode.png;
      devour sxiv -b /tmp/grencode.png
    '';
  };


  home.sessionPath = [ 
    # add bin directory to path
    "${config.dots.binDir}"
  ];

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    options = [ "fzf" ];
  };


  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      scan_timeout = 10;
      add_newline = false;
      character.symbol = "➜ ";
      line_break.disabled = true;
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
        "hg_branch"
        "docker_context"
        "package"
        "cmake"
        "dart"
        "dotnet"
        "elixir"
        "elm"
        "erlang"
        "golang"
        "helm"
        "java"
        "julia"
        "nim"
        "nodejs"
        "ocaml"
        "perl"
        "php"
        "purescript"
        "python"
        "ruby"
        "rust"
        "swift"
        "terraform"
        "zig"
        "nix_shell"
        "conda"
        "memory_usage"
        "aws"
        "gcloud"
        "env_var"
        "crystal"
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

  programs.zsh.plugins = with pkgs; [
    {
      name = "fast-syntax-highlighting";
      src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    }
    {
      name = "fzf-tab";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "a7c4890445d6c7a8cc7b64fed3c4e62711ad5b5f";
        sha256 = "1x3xwbqxknkwa891q1bnzvaikx45hfdhhi6l617ik15z3j9wjb06";
      };
      file = "fzf-tab.zsh";
    }
    {
      name = "zsh-autopair";
      src = fetchFromGitHub {
        owner = "hlissner";
        repo = "zsh-autopair";
        rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
        sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
      };
      file = "autopair.zsh";
    }
    {
      name = "zsh-system-clipboard";
      src = fetchFromGitHub {
        owner = "kutsan";
        repo = "zsh-system-clipboard";
        rev = "v0.7.0";
        sha256 = "09lqav1mz5zajklr3xa0iaivhpykv3azkjb7yj9wyp0hq3vymp8i";
      };
      file = "zsh-system-clipboard.zsh";
    }
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd -HL --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--select-1"
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

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    newSession = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [ 
      {
        plugin = fzf-tmux-url;
      }
      {
        # FIXME: doesn't work well in NixOS
        # https://github.com/tmux-plugins/tmux-resurrect/issues/247
        # https://github.com/NixOS/nixpkgs/issues/78033
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim "session"
          set -g @resurrect-dir "~/.local/share/tmux/resurrect"
        '';
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig = builtins.readFile "${config.dots.confDir}/tmux/tmux.conf";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins // pkgs.callPackage ./custom/neovim-plugins.nix {}; [
      {
        plugin = fzf-checkout;
        config = ''
          nnoremap <silent> <leader>gb :GBranches<CR>
          '';
      }
      {
        plugin = nvim-colorizer;
        config = "lua require'colorizer'.setup()";
      }
      {
        plugin = fzf-vim;

        # TODO: add fzf function for cd
        config = ''
          let g:fzf_layout = { "window": { "width": 0.8, "height": 0.6 } }


          nnoremap <silent> <leader>q :Files<CR>
          nnoremap <silent> <leader>fh :History<CR>
          nnoremap <silent> <leader><leader>; :History:<CR>

          nnoremap <silent> <leader>, :Windows<CR>
          nnoremap <silent> <leader>w :Buffers<CR>

          nnoremap <leader>p :cd %:h<CR>

          nnoremap <silent> <leader>/ :BLines<CR>
          nnoremap <silent> <leader>? :Lines<CR>
          nnoremap <silent> <leader><leader>/ :History/<CR>
          nnoremap <silent> <leader>; :Commands<CR>
          nnoremap <silent> <leader><CR> :Marks<CR>
          nnoremap <leader>r :Rg 
          nnoremap <leader>gf :GFiles<CR>
          nnoremap <leader>gc :Commits<CR>
          nnoremap <leader>bc :BCommits<CR>
        '';
      }
      fzfWrapper
      {
        plugin = vim-fugitive;
        config = ''
          nnoremap <leader>gg :G<CR>
          nnoremap <leader>gl :Gllog<CR>
        '';
      }
      vim-surround
      vim-commentary
      vim-repeat
      vim-obsession # for tmux-resurrect
      vim-polyglot
      vim-devicons
      vim-lion
      auto-pairs
      {
        plugin = indentLine;
        config = ''
          let g:indentLine_enabled = 0
          let g:indentLine_char = "|"
          '';
      } 
      {
        plugin = dracula-vim;
        config = ''
          packadd! dracula-vim
          colorscheme dracula
        '';
      }
      {
        plugin = lightline-vim;
        config = ''
          function! LightlineReadonly()
            return &readonly ? "" : ""
          endfunction

          function! LightlineFugitive()
            if exists("*FugitiveHead")
                let branch = FugitiveHead()
                return branch !=# "" ? "".branch : ""
            endif
            return ""
          endfunction

          let g:lightline = {
            \ "colorscheme": "dracula",
              \ "active": {
              \   "left": [ [ "mode", "paste" ], [ "readonly","fugitive", "absolutepath", "modified" ] ]
              \ },
              \ "component_function": {
              \   "readonly": "LightlineReadonly",
              \   "fugitive": "LightlineFugitive"
              \ },
              \ }
        '';
      }
      {
        plugin = ultisnips;
        config = "let g:UltiSnipsSnippetDirectories=[\"${config.dots.confDir}/nvim/UltiSnips\"]";
      }
      vim-snippets
    ];
    extraConfig = builtins.readFile "${config.dots.confDir}/nvim/init.vim";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 10000;
    defaultCacheTtlSsh = 10000;
  };

  programs.password-store.enable = true;
  programs.password-store.settings = {
    PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
  };

  services.syncthing.enable = true;

  programs.ssh.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
  };

  # NOTE: extensions must be enabled manually
  programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    https-everywhere
    ublock-origin
    tridactyl
    browserpass
  ];

  programs.firefox.profiles.${config.dots.userName} = {
    name = "${config.dots.userName}";
    isDefault = true;
    userContent = ''
        :root{ scrollbar-width: none !important } 
    '';
    settings = {
      "devtools.theme" = "dark";
      "browser.download.dir" = "${config.home.homeDirectory}/dl";
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
      # Enable OpenGL compositor
      "layers.acceleration.force-enabled" = true;
      # Enable WebRender compositor
      "gfx.webrender.all" = true;

      # Move disk cache to RAM
      "browser.cache.disk.parent_directory" = "/run/user/1000/firefox";

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
    };
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  home.file.tridactylManifest = {
    source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
    target = ".mozilla/native-messaging-hosts/tridactyl.json";
  };

  home.file.tridactylNative = {
    source = "${pkgs.tridactyl-native}/share/tridactyl/native_main.py";
    target = ".local/share/tridactyl/native_main.py";
  };

  # FIXME: editor doesn't use user config
  home.file.tridactylrc = {
    text = ''
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
      set editorcmd ${pkgs.xst}/bin/xst -e ${pkgs.neovim}/bin/nvim %f "+normal!%lGzv%c|"

      " C-c C-p
      " make d take you to the tab you were just on (I find it much less confusing)
      bind d composite tab #; tabclose #
      bind D tabclose
      " Stupid workaround to let hint -; be used with composite which steals semi-colons
      command hint_focus hint -;
      bind ;C composite hint_focus; !s xdotool key Menu
    '';
    target = ".config/tridactyl/tridactylrc";
  };

  xresources.properties = {
    "*.foreground" = "#F8F8F2";
    "*.background" = "#1E2029";
    "*.color0"  = "#000000";
    "*.color8"  = "#4D4D4D";
    "*.color1"  = "#FF5555";
    "*.color9"  = "#FF6E67";
    "*.color2"  = "#50FA7B";
    "*.color10" = "#5AF78E";
    "*.color3"  = "#F1FA8C";
    "*.color11" = "#F4F99D";
    "*.color4"  = "#BD93F9";
    "*.color12" = "#CAA9FA";
    "*.color5"  = "#FF79C6";
    "*.color13" = "#FF92D0";
    "*.color6"  = "#8BE9FD";
    "*.color14" = "#9AEDFE";
    "*.color7"  = "#BFBFBF";
    "*.color15" = "#E6E6E6";
    "st.font" = "JetBrains Mono nerd font:pixelsize=16:antialias=true:autohint=true";
    "st.bold_font" = 1;
    "st.italic_font" = 1;
    "st.roman_font" = 1;
    "st.termname" = "st-256color";
  };

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

  programs.zathura.enable = true;
  programs.zathura.options = {
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

  programs.mpv = {
    enable = true;
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

  xdg.configFile."latexmk/latexmkrc".text = ''
    $xelatex = "xelatex --shell-escape %O %S";
    $pdf_mode = 5;
    $interaction = "nonstopmode";
    $preview_continuous_mode = 1;
    $pdf_previewer="zathura %S";
  '';

  xdg.configFile."sxiv" = {
    source = "${config.dots.confDir}/sxiv";
    recursive = true;
  };

  programs.git = {
    enable = true;
    userEmail = "0qqw0qqw@gmail.com";
    userName = "qq";
    ignores = [
      "Session.vim"
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
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  # https://github.com/rakshasa/rtorrent/wiki/User-Guide
  programs.rtorrent = {
    enable = true;
  };

  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls = import "${config.home.homeDirectory}/rss.nix";
  };

  programs.noti.enable = true;
}
