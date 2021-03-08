{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    terraform_0_14
    terraform-ls
  ];


  home.file.".terraformrc".text = ''
    plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
  '';


  programs.zsh = {
    initExtra = ''
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C ${pkgs.terraform_0_14}/bin/terraform terraform
    '';
    shellAliases = {
      tf = "terraform";
    };
  };
}
