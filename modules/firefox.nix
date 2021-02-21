{ config, pkgs, ... }:

let
  user = config.dots.userName;
  home = config.home.homeDirectory;
  uid = builtins.toString config.dots.uid;
in
  {
    home.packages = with pkgs; [
      tridactyl-native
      # buku
    ];


    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
    };


    programs.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      stylus
      ublock-origin
      tridactyl
      browserpass
    ];


    programs.firefox.profiles.${user} = {
      name = "${user}";
      isDefault = true;
      userContent = ''
        :root{ scrollbar-width: none !important } 
      '';
      settings = {
        "devtools.theme" = "dark";
        "browser.download.dir" = "${home}/dl";
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
        "full-screen-api.ignore-widgets"  = true;
      };
    };


    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };


    home.file = {
      tridactylManifest = {
        source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
        target = ".mozilla/native-messaging-hosts/tridactyl.json";
      };
      tridactylNative = {
        source = "${pkgs.tridactyl-native}/share/tridactyl/native_main.py";
        target = ".local/share/tridactyl/native_main.py";
      };
    };


    xdg.configFile."tridactyl/tridactylrc".text = ''
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
      set editorcmd ${pkgs.xst}/bin/xst -c nvimedit -e ${pkgs.neovim}/bin/nvim %f "+normal!%lGzv%c|"

      " C-c C-p
      " make d take you to the tab you were just on (I find it much less confusing)
      bind d composite tab #; tabclose #
      bind D tabclose
      " Stupid workaround to let hint -; be used with composite which steals semi-colons
      command hint_focus hint -;
      bind ;C composite hint_focus; !s xdotool key Menu
    '';
  }
