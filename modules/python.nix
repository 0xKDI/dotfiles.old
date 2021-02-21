{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python38
    python38Packages.ipython
    python38Packages.pip
  ];


  xdg.configFile."pythonrc".text = ''
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
