self: super:
{
  vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };


  vimPlugins = super.vimPlugins // super.callPackage ./vimPlugins.nix { };


  latex = super.texlive.combine {
    inherit (super.texlive)
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
  };
}
