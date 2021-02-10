{ config, lib, pkgs, ... }:

{
  # https://www.kernel.org/doc/html/v5.3/gpu/i915.html
  boot.kernelModules = [ "i915" ];


  # disable nvidia, very nice battery life.
  # bumblebee.service will fall, reboot needed
  hardware.nvidiaOptimus.disable = true;


  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];


  services.xserver = {
    videoDrivers = [ "intel" ];
    useGlamor = true;
  };
  

  # https://nixos.wiki/wiki/Accelerated_Video_Playback
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };


  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };
}
