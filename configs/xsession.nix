{ config, pkgs, ... }:

let
  binPath = "${config.dir}/bin";
  dataHome = config.xdg.dataHome;
  configHome = config.xdg.configHome;
  cacheHome = config.xdg.cacheHome;
  dotDir = config.dir;
in
  {
    home.sessionPath = [
      "${binPath}"
    ];


    home.sessionVariables = {
      DOTS = "${dotDir}";
      TEXMFHOME = "${dataHome}/texmf";
      TEXMFVAR = "${cacheHome}/texlive/texmf-var";
      TEXMFCONFIG = "${configHome}/texlive/texmf-config";
      DOCKER_CONFIG = "${configHome}/docker";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
      PYTHONSTARTUP = "${configHome}/pythonrc";
      DDGR_COLORS = "oCdgxf"; # duckduckgo-cli colors

      # z-lua
      _ZL_CMD = "q";
      _ZL_DATA = "${dataHome}/zlua";

      # clipmenu
      CM_LAUNCHER = "fzf";
      CM_HISTLENGTH = 150;

      # editor
      VISUAL = "nvim";
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";

      MANPAGER = "nvim +Man!";
      MANWIDTH = 999;

      AWS_SHARED_CREDENTIALS_FILE = "${configHome}/aws/credentials";
      AWS_CONFIG_FILE = "${configHome}/aws/config";

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

      # Ruby
      GEM_HOME = "${dataHome}/gem";
      GEM_SPEC_CACHE = "${cacheHome}/gem";

      # Jupiter/IPython
      IPYTHONDIR = "${configHome}/jupyter";
      JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
    };
  }
