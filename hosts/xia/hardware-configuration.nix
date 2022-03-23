{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];


  boot = {
    kernelParams = [ "intel_idle.max_cstate=1" ];
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
    };
    cleanTmpDir = true;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_usb_sdmmc"
      ];
      kernelModules = [ ];
      luks.devices."cryptroot".device = "/dev/disk/by-label/cryptroot";
    };
    kernelModules = [ "kvm-intel" "i915" ];
    blacklistedKernelModules = [ "nouveau" "nvidia" ];
    extraModulePackages = [ ];
    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
  };


  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };


  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };


  swapDevices = [ ];


  services = {
    fstrim.enable = true;
    # This will save you money and possibly your life!
    thermald.enable = true;
  };


  hardware = {
    cpu.intel.updateMicrocode = true;
    # disable nvidia, very nice battery life.
    # bumblebee.service will fall, reboot needed
    nvidiaOptimus.disable = true;
    keyboard.zsa.enable = true;
    pulseaudio = {
      enable = true;
      extraConfig = ''
        unload-module module-suspend-on-idle
        # prevents ~/.esd_auth
        unload-module module-esound-protocol-unix
      '';
    };
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };
}
