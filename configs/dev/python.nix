{ config, pkgs, ... }:

let
  configHome = config.xdg.configHome;
in
{
  home.packages = with pkgs; [
    python39
    python39Packages.ipython
    python39Packages.pip
  ];


  programs.zsh.shellAliases = {
    py3 = "python3";
    py2 = "python2";
    py = "python3";
  };


  home.sessionVariables = {
    PYTHONSTARTUP = "${configHome}/pythonrc";

    # Jupiter/IPython
    IPYTHONDIR = "${configHome}/jupyter";
    JUPYTER_CONFIG_DIR = "${configHome}/jupyter";
  };


  xdg.configFile."pythonrc.py".text = ''
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
}
