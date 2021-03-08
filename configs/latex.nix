{ config, pkgs, ... }:

let
  dataHome = config.xdg.dataHome;
  configHome = config.xdg.configHome;
  cacheHome = config.xdg.cacheHome;
in
{
  xdg.configFile."latexmk/latexmkrc".text = ''
    $xelatex = "xelatex --shell-escape %O %S";
    $pdf_mode = 5;
    $interaction = "nonstopmode";
    $preview_continuous_mode = 1;
    $pdf_previewer = "zathura %S";
    $clean_ext = "_minted-%R/* _minted-%R";
  '';

  home.sessionVariables = {
    TEXMFHOME = "${dataHome}/texmf";
    TEXMFVAR = "${cacheHome}/texlive/texmf-var";
    TEXMFCONFIG = "${configHome}/texlive/texmf-config";
  };


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
