{ config, lib, pkgs, ... }:

{

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/cryptroot";

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 1;
  };

  services.fstrim.enable = true;
}
