{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.latex;
in
{
  options.modules.latex = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python38Packages.pygments
      corefonts # Microsoft fonts
      (texlive.combine {
        inherit (texlive)
          scheme-small
          latexmk
          polyglossia
          geometry
          fancyhdr
          titlesec
          bigfoot
          setspace
          hyphenat
          blindtext
          xurl
          hyperref
          footmisc
          enumitem
          graphics
          float
          pgf
          pdfpages
          caption
          subfig
          tabulary
          booktabs
          diagbox
          multirow
          xltabular
          makecell
          floatrow
          minted
          etoolbox
          lastpage
          cite
          csquotes
          chngcntr
          was
          pict2e
          ltablex
          fvextra
          catchfile
          xstring
          framed
          upquote
          totcount
          wrapfig; # required for beamer style
      })
    ];


    xdg.configFile."latexmk/latexmkrc".text = ''
      $xelatex = "xelatex --shell-escape %O %S";
      $pdf_mode = 5;
      $interaction = "nonstopmode";
      $preview_continuous_mode = 1;
      $pdf_previewer = "zathura %S";
      $clean_ext = "_minted-%R/* _minted-%R";
    '';
  };
}
