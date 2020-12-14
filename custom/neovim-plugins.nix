{ pkgs, ... }:

{
  fzf-checkout = pkgs.vimUtils.buildVimPlugin {
    pname = "fzf-checkout";
    version = "2020-11-09";
    buildPhase = "echo hi";
    src = pkgs.fetchFromGitHub {
      owner = "stsewd";
      repo = "fzf-checkout.vim";
      rev = "e9f8f6592ba04e3e2d31c64a77acc5a6bce012d8";
      sha256 = "09g08gsm7sjmnyfbydc8s4jfnrw8fk3qyjl7dd2bifm5w3kqk924";
    };
  };

  nvim-colorizer = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-colorizer";
    version = "2020-11-09";
    src = pkgs.fetchFromGitHub {
      owner = "norcalli";
      repo = "nvim-colorizer.lua";
      rev = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6";
      sha256 = "0gvqdfkqf6k9q46r0vcc3nqa6w45gsvp8j4kya1bvi24vhifg2p9";
    };
  };
  nvim-lspfuzzy = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-lspfuzzy";
    version = "2020-12-14";
    src = pkgs.fetchFromGitHub {
      owner = "ojroques";
      repo = "nvim-lspfuzzy";
      rev = "6b5dc735709aa3c67268d1c310b35f65ee86c7ef";
      sha256 = "0jbx5mac95nnbm1jnzdhkgxidin17lwg9gyvsqn0qcdly4gl4iqk";
    };

  };

}
