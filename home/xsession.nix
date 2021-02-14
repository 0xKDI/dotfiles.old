{ config, pkgs, ... }:

{
  home.sessionPath = [
    "${config.dots.binDir}"
  ];


  home.sessionVariables = {
    DOTS = "/etc/nixos";
    TEXMFHOME = "${config.xdg.dataHome}/texmf";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
    TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    PYTHONSTARTUP = "${config.xdg.configHome}/python/startup.py";
    DDGR_COLORS = "oCdgxf"; # duckduckgo-cli colors

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
    XCOMPOSEFILE = "${config.xdg.configHome}/X11/xcompose";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    # same with .xsession_errors
    USERXSESSION = "${config.xdg.cacheHome}/X11/xsession";
    USERXSESSIONRC = "${config.xdg.cacheHome}/X11/xsessionrc";
    ALTUSERXSESSION = "${config.xdg.cacheHome}/X11/Xsession";
    ERRFILE = "${config.xdg.cacheHome}/X11/xsession-errors";

    PARALLEL_HOME = "${config.xdg.configHome}/parallel";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";

    # Ruby
    GEM_HOME = "${config.xdg.dataHome}/gem";
    GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";

    # Jupiter/IPython
    IPYTHONDIR = "${config.xdg.configHome}/jupyter";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
  };
}

