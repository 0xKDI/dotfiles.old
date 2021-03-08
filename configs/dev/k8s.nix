{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    minikube
    kubectl
    kubernetes-helm
  ];


  programs.zsh.shellAliases = {
    k = "kubectl";
    ka = "kubectl apply";
    kg = "kubectl get";
    kd = "kubectl describe";
    ke = "kubectl explain";
    kdel = "kubectl delete";
  };
}
