{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mpvc # a mpc-like control interface for mpv
  ];


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
}
