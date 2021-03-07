{ config, pkgs, ... }:

let
  alias_dir = "$PWD/.direnv/aliases";
  alias_target = "${alias_dir}/$name";
in 
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
    stdlib = ''
      export_alias() {
        local name=$1
        shift
        mkdir -p "${alias_dir}"
        PATH_add "${alias_dir}"
        echo "#!/usr/bin/env -S bash -e" > "${alias_target}"
        echo "$@" >> "${alias_target}"
        chmod +x "${alias_target}"
      }
    '';
  };
}
