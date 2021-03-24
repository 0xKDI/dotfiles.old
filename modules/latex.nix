{ config, pkgs, lib, ... }:

with lib;
let 
  cfg = config.programs.latex;
in
{
  options.programs.latex = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };


  config = mkIf cfg.enable {
    home.packages = with pkgs; [
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
];
  };
}
