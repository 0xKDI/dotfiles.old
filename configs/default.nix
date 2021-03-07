{ config, pkgs, ... }:

{
  imports = [
    ./cli
    ./desktop
    ./dev
    ./neovim
    ./sxiv
    ./tmux

    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./latex.nix
    ./mpv.nix
    ./nix.nix
    ./pass.nix
    ./st.nix
    ./systemd.nix
    ./zathura.nix
    ./zsh.nix
  ];
}
