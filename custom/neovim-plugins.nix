{ pkgs, ... }:

{
  fzf-checkout = pkgs.vimUtils.buildVimPlugin {
    pname = "fzf-checkout";
    version = "2020-11-09";
    buildPhase = "echo 'Do not use makefile'";
    src = pkgs.fetchFromGitHub {
      owner = "stsewd";
      repo = "fzf-checkout.vim";
      rev = "e9f8f6592ba04e3e2d31c64a77acc5a6bce012d8";
      sha256 = "09g08gsm7sjmnyfbydc8s4jfnrw8fk3qyjl7dd2bifm5w3kqk924";
    };
  };

}
