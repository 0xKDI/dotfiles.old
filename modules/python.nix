{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.programs.python;
in
{
  options.programs.python = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python39
      python39Packages.ipython
      python39Packages.pip
    ];
  };
}
