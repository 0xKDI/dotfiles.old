{ config, pkgs, ... }:

{
  imports = [
    ./go.nix
    ./python.nix
    ./terraform.nix
    ./k8s.nix
    ./cloud.nix
  ];
}
