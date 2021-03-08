{ config, pkgs, ... }:

let
  binPath = "../bin";
  dataHome = config.xdg.dataHome;
  configHome = config.xdg.configHome;
  cacheHome = config.xdg.cacheHome;
  dotDir = "/etc/nixos";
in
{
  home.sessionPath = [
    "${binPath}"
  ];


  home.sessionVariables = {
    DOTS = "${dotDir}";
    DOCKER_CONFIG = "${configHome}/docker";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
    DDGR_COLORS = "oCdgxf"; # duckduckgo-cli colors

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
  };
}
