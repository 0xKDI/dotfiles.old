{ config, pkgs, ... }:

{
  xdg.configFile."latexmk/latexmkrc".source = "${config.dots.confDir}/latexmkrc.rb";


  home.packages = with pkgs; [
    python38Packages.pygments
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
      totcount;
    })
    corefonts # Microsoft fonts
  ];
}
